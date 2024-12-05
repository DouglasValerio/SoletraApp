import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:soletra_app/bloc/letters/letters_bloc.dart';
import 'package:soletra_app/bloc/word_game/word_game_bloc.dart';
import 'package:soletra_app/external/http/dio_client.dart';
import 'package:soletra_app/external/pub_sub/pub_nub_service.dart';
import 'package:soletra_app/external/pub_sub/pub_nub_service_impl.dart';
import 'package:soletra_app/external/storage/storage_service.dart';
import 'package:soletra_app/external/storage/storage_service_impl.dart';
import 'package:soletra_app/repositories/live_game_repository.dart';
import 'package:soletra_app/repositories/live_game_repository_impl.dart';
import 'package:soletra_app/repositories/word_game_repository.dart';
import 'package:soletra_app/repositories/word_game_repository_impl.dart';

GetIt injector = GetIt.instance;

Future<void> setupInjection() async {
  await Hive.initFlutter();
  await _storageInjection();
  await _wordGameInjection();
  await _lettersInjection();
}

Future<void> _wordGameInjection() async {
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
  injector.registerFactory<DioClient>(() => DioClient());

  injector.registerFactory<PubNubService>(() => PubNubServiceImpl());
}

Future<void> _lettersInjection() async {
  injector.registerLazySingleton<LettersBloc>(
    () => LettersBloc(
      wordGameRepository: injector<WordGameRepository>(),
    ),
  );
}

Future<void> _storageInjection() async {
  final box = await Hive.openBox('soletra_box');
  injector.registerSingletonAsync<StorageService>(
    () async {
       
      return StorageServiceImpl(box: box);
    },
  );
}
