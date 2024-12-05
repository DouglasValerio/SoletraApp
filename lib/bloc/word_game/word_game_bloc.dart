import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pubnub/pubnub.dart';

import 'package:soletra_app/models/models.dart';
import 'package:soletra_app/repositories/live_game_repository.dart';

import '../../repositories/word_game_repository.dart';

part 'word_game_event.dart';
part 'word_game_state.dart';

class WordGameBloc extends Bloc<WordGameEvent, WordGameState> {
  final WordGameRepository _wordGameRepository;
  final LiveGameRepository _liveGameRepository;
  WordGameBloc({
    required WordGameRepository wordGameRepository,
    required LiveGameRepository liveGameRepository,
  })  : _liveGameRepository = liveGameRepository,
        _wordGameRepository = wordGameRepository,
        super(WordGameInitial()) {
    _liveGameRepository.liveGame().then((stream) {
      stream.listen((event) async {
        add(WordGameScoreFromPartner(word: event.word));
      });
    });

    on<WordGameEvent>((event, emit) async {
      if (event is WordGameStarted) {
        await _mapWordGameStartedToState(emit);
      } else if (event is WordGameSubmitted) {
        _mapWordGameSubmittedToState(event, emit);
      } else if (event is WordGameScoreFromPartner) {
        _mapWordGameScoreFromPartnerToState(event, emit);
      }
    });
  }
  List<WordModel> _stateCache = [];

  final pubnub = PubNub(
      defaultKeyset: Keyset(
          subscribeKey: 'sub-c-e979a112-e58b-46ce-b966-d61cb8150ca3',
          publishKey: 'pub-c-47c1389d-9167-4d94-9693-f4097d60bace',
          userId: const UserId('25b1788f-3523-4a6c-a3d6-f2ab5feb213b')));

  Future<void> _mapWordGameStartedToState(Emitter<WordGameState> emit) async {
    _stateCache = await _wordGameRepository.getWordGame();
    emit(WordGameSuccess(wordGameModel: _stateCache, index: -1));
  }

  void _mapWordGameSubmittedToState(
      WordGameSubmitted event, Emitter<WordGameState> emit) async {
    emit(WordGameLoading());
    if (_stateCache.isEmpty) {
      _stateCache = await _wordGameRepository.getWordGame();
    }
    final index = _stateCache.indexWhere(
        (element) => element.word.toLowerCase() == event.word.toLowerCase());
    if (index != -1) {
      if (_stateCache[index].isFound) {
        emit(WordAlreadyFound(wordGameModel: _stateCache, index: index));
        return;
      }
      _stateCache[index] = _stateCache[index].setAsFound();
      _liveGameRepository.sendWord(_stateCache[index]);
      emit(WordFindByPlayer(wordGameModel: _stateCache, index: index));
      return;
    }

    emit(WordNotIncludedOnGame(wordGameModel: _stateCache));
  }

  void _mapWordGameScoreFromPartnerToState(
      WordGameScoreFromPartner event, Emitter<WordGameState> emit) async {
    if (_stateCache.isEmpty) {
      _stateCache = await _wordGameRepository.getWordGame();
    }
    final index = _stateCache.indexWhere(
        (element) => element.word.toLowerCase() == event.word.toLowerCase());
    if (index != -1) {
      _stateCache[index] = _stateCache[index].setAsFound();

      emit(WordFoundByPartner(
          wordGameModel: _stateCache,
          index: index,
          message:
              "Palavra ${event.word.toUpperCase()} encontrada pelo seu parceiro"));
      return;
    }
  }
}
