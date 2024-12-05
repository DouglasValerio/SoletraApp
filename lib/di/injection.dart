import 'package:get_it/get_it.dart';
import 'package:soletra_app/bloc/letters/letters_bloc.dart';
import 'package:soletra_app/bloc/word_game/word_game_bloc.dart';
import 'package:soletra_app/http/dio_client.dart';
import 'package:soletra_app/repositories/live_game_repository.dart';
import 'package:soletra_app/repositories/live_game_repository_impl.dart';
import 'package:soletra_app/repositories/word_game_repository.dart';
import 'package:soletra_app/repositories/word_game_repository_impl.dart';

GetIt injector = GetIt.instance;

Future<void> setupInjection() async {
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
  injector.registerFactory<LiveGameRepository>(() => LiveGameRepositoryImpl());
  injector.registerFactory<DioClient>(() => DioClient());
}

Future<void>_lettersInjection ()async{
  injector.registerLazySingleton<LettersBloc>(
    () => LettersBloc(
        wordGameRepository: injector<WordGameRepository>(),),
  );
}
