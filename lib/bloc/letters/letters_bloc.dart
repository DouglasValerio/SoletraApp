import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:soletra_app/models/letters_model.dart';
import 'package:soletra_app/repositories/word_game_repository.dart';

part 'letters_event.dart';
part 'letters_state.dart';

class LettersBloc extends Bloc<LettersEvent, LettersState> {
  final WordGameRepository _wordGameRepository;
  LettersBloc({required WordGameRepository wordGameRepository})
      : _wordGameRepository = wordGameRepository,
        super(LettersInitial()) {
    on<LettersEvent>((event, emit) async {
      if (event is LettersStarted) {
        await _mapLettersStartedToState(emit);
      }
      if (event is LettersRefresh) {
        await _mapLettersRefreshToState(emit);
      }
    });
  }
  LettersModel? _stateCache;

  Future<void> _mapLettersStartedToState(Emitter<LettersState> emit) async {
    emit(LettersLoading());
    final lettersModel = await _wordGameRepository.getAvailableLetters();
    _stateCache = lettersModel;
    emit(LettersSuccess(lettersModel: lettersModel));
  }

  Future<void> _mapLettersRefreshToState(Emitter<LettersState> emit) async {
    emit(LettersLoading());
    _stateCache ??= await _wordGameRepository.getAvailableLetters();
    _stateCache = _stateCache!.shuffleLetters();
    emit(LettersSuccess(lettersModel: _stateCache!));
  }
}
