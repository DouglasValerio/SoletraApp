import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pubnub/pubnub.dart';
import 'package:soletra_app/bloc/letters/letters_bloc.dart';
import 'package:soletra_app/bloc/word_game/word_game_bloc.dart';
import 'package:soletra_app/di/injection.dart';
import 'package:soletra_app/external/http/dio_client.dart';
import 'package:soletra_app/external/pub_sub/pub_nub_service.dart';
import 'package:soletra_app/external/storage/storage_service.dart';

import 'package:soletra_app/main.dart';
import 'package:soletra_app/repositories/live_game_repository.dart';
import 'package:soletra_app/repositories/live_game_repository_impl.dart';
import 'package:soletra_app/repositories/word_game_repository.dart';
import 'package:soletra_app/repositories/word_game_repository_impl.dart';

class _MockDioClient extends Mock implements DioClient {}

class _MockStorageService extends Mock implements StorageService {}

class _MockPubNubService extends Mock implements PubNubService {}

class _FakeUUID extends Mock implements UUID {
  @override
  String get value => 'some_id';
}

class _FakeEnvelope extends Mock implements Envelope {
  @override
  String get payload =>
      '{"word": "caco", "score": 1, "pangram": false, "label": []}';
  @override
  UUID get uuid => _FakeUUID();    
}



Future<void> _injectionForTesting() async {
  injector.registerLazySingleton<WordGameBloc>(
    () => WordGameBloc(
        wordGameRepository: injector<WordGameRepository>(),
        liveGameRepository: injector<LiveGameRepository>()),
  );
  injector.registerFactory<WordGameRepository>(
    () => WordGameRepositoryImpl(
      dioClient: injector<DioClient>(),
    ),
  );
  injector.registerFactory<LiveGameRepository>(() => LiveGameRepositoryImpl(
        pubNubService: injector<PubNubService>(),
        storageService: injector<StorageService>(),
      ));
  injector.registerLazySingleton<LettersBloc>(
    () => LettersBloc(
      wordGameRepository: injector<WordGameRepository>(),
    ),
  );
  //register the mocks
  injector.registerSingleton<DioClient>(_MockDioClient());
  injector.registerSingleton<StorageService>(_MockStorageService());
  injector.registerSingleton<PubNubService>(_MockPubNubService());
}

void _registerMethods() {
  when(() => injector<StorageService>().getSessionId())
      .thenAnswer((_) async => 'some_session_id');
  when(() => injector<DioClient>().get('/game')).thenAnswer((_) async =>
      Response(
          requestOptions: RequestOptions(path: '/game'),
          statusCode: 200,
          data: [
            {"word": "anca", "score": 1, "pangram": false, "label": []},
            {"word": "caco", "score": 1, "pangram": false, "label": []}
          ]));
  when(() => injector<DioClient>().get('/game/letters')).thenAnswer((_) async =>
      Response(
          requestOptions: RequestOptions(path: '/game'),
          statusCode: 200,
          data: {
            "centralLetter": "c",
            "outerLetters": ["a", "d", "n", "o", "t", "u"]
          }));

  when(() => injector<PubNubService>().liveGame(any()))
      .thenAnswer((_) => const Stream.empty());
  when(() => injector<PubNubService>().sendEvent(any(), any(), any()))
      .thenAnswer((_) => Future.value());
}

void main() {
  setUp(() async {
    await _injectionForTesting();
    _registerMethods();
  });

  tearDown(() {
    injector.reset();
  });

  testWidgets('Ensure UI loads game with data from [mock]remote',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    ["a", "d", "n", "o", "t", "u"]
        .map((e) => e.toUpperCase())
        .forEach((letter) {
      expect(find.text(letter), findsOneWidget);
    });
  });

  testWidgets('Ensure User input is registered', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    const letters = ["c", "a", "c", "o"];

    for (var i = 0; i < letters.length; i++) {
      await tester.tap(find.text(letters[i].toUpperCase()));
      await tester.pumpAndSettle();
    }
    final textFieldFinder = find.byType(TextField);
    final textField = tester.widget<TextField>(textFieldFinder);
    expect(textField.controller!.text, letters.join().toUpperCase());
  });

  testWidgets(
      'Ensure that word is saved on the UI when user inputs and submits',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    const letters = ["c", "a", "c", "o"];

    for (var i = 0; i < letters.length; i++) {
      await tester.tap(find.text(letters[i].toUpperCase()));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();

    //ensure textfield is cleared
    final textFieldFinder = find.byType(TextField);
    final textField = tester.widget<TextField>(textFieldFinder);
    expect(textField.controller!.text, isEmpty);
    await tester.pumpAndSettle();
//ensure word is displayed
    expect(find.text('Caco'), findsOneWidget);
  });

  testWidgets(
      'Ensure that user can delete input with tap and hold on the "Apagar" button',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    const letters = ["c", "a", "c", "o"];

    for (var i = 0; i < letters.length; i++) {
      await tester.tap(find.text(letters[i].toUpperCase()));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Apagar'));
    await tester.pumpAndSettle();

    //ensure last letter is removed
    final textFieldFinder = find.byType(TextField);
    final textField = tester.widget<TextField>(textFieldFinder);
    expect(textField.controller!.text, "CAC");

    await tester.longPress(find.text('Apagar'));
    await tester.pumpAndSettle();
//ensure input is cleared
    expect(textField.controller!.text, isEmpty);
  });
  testWidgets('Ensure that user can shuffle letters with tap on refresh button',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final lettersWidgets = find.byType(CircleAvatar);
    final firstLetterBefore =
        tester.widget<CircleAvatar>((lettersWidgets.first));
    await tester.tap(find.byIcon(Icons.refresh_outlined));
    await tester.pumpAndSettle();
// ensure letters are shuffled
    final firstLetterAfter = tester.widget<CircleAvatar>(lettersWidgets.first);
    expect(firstLetterBefore.child, isNot(equals(firstLetterAfter.child)));
  });

  testWidgets(
      'Ensure that word is saved on the UI when event from partner is received',
      (WidgetTester tester) async {
    when(() => injector<PubNubService>().liveGame(any()))
        .thenAnswer((_) => Stream.fromIterable([_FakeEnvelope()]));

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

//ensure word is displayed
    expect(find.text('Caco'), findsOneWidget);
  });
}
