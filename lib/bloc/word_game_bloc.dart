// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:soletra_app/models/models.dart';

import '../repositories/word_game_repository.dart';

part 'word_game_event.dart';
part 'word_game_state.dart';

class WordGameBloc extends Bloc<WordGameEvent, WordGameState> {
  final WordGameRepository _wordGameRepository;
  WordGameBloc(
    {required WordGameRepository wordGameRepository,}
  ) : _wordGameRepository = wordGameRepository, super(WordGameInitial()) {
    on<WordGameEvent>((event, emit) {
      if (event is WordGameStarted) {
        _mapWordGameStartedToState(emit);
      } else if (event is WordGameSubmitted) {
        _mapWordGameSubmittedToState(event, emit);
      }
    });
  }
  void _mapWordGameStartedToState(Emitter<WordGameState> emit)async {
  final wordGameModel = await _wordGameRepository.getWordGame();
  emit(WordGameSuccess(wordGameModel: wordGameModel));
}

  void _mapWordGameSubmittedToState(WordGameSubmitted event, Emitter<WordGameState> emit)async {
    emit(WordGameLoading());
   final words = await _wordGameRepository.getWordGame();
    emit(WordGameSuccess(wordGameModel: words));
  }
}


