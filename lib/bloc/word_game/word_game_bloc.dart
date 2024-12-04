// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:soletra_app/models/models.dart';

import '../../repositories/word_game_repository.dart';

part 'word_game_event.dart';
part 'word_game_state.dart';

class WordGameBloc extends Bloc<WordGameEvent, WordGameState> {
  final WordGameRepository _wordGameRepository;
  WordGameBloc({
    required WordGameRepository wordGameRepository,
  })  : _wordGameRepository = wordGameRepository,
        super(WordGameInitial()) {
    on<WordGameEvent>((event, emit) {
      if (event is WordGameStarted) {
        _mapWordGameStartedToState(emit);
      } else if (event is WordGameSubmitted) {
        _mapWordGameSubmittedToState(event, emit);
      }
    });
  }
  List<WordModel> _stateCache = [];
  void _mapWordGameStartedToState(Emitter<WordGameState> emit) async {
    _stateCache = await _wordGameRepository.getWordGame();
    emit(WordGameSuccess(wordGameModel: _stateCache));
  }

  void _mapWordGameSubmittedToState(
      WordGameSubmitted event, Emitter<WordGameState> emit) async {
    emit(WordGameLoading());
    if(_stateCache.isEmpty){
      _stateCache = await _wordGameRepository.getWordGame();
    }
    final index = _stateCache.indexWhere(
        (element) => element.word.toLowerCase() == event.word.toLowerCase());
    if (index != -1) {
      _stateCache[index] = _stateCache[index].setAsFound();
    emit(WordGameSuccess(wordGameModel: _stateCache));
    return;
    }
    emit(WordGameFailedAttempt(wordGameModel: _stateCache));
  }
}
