part of 'word_game_bloc.dart';

@immutable
sealed class WordGameState {}

final class WordGameInitial extends WordGameState {}
final class WordGameLoading extends WordGameState {}
final class WordGameSuccess extends WordGameState {
  final List<WordModel> wordGameModel;

  WordGameSuccess({required this.wordGameModel});
}
class WordGameFailedAttempt extends WordGameState {
  final List<WordModel> wordGameModel;

  WordGameFailedAttempt({required this.wordGameModel});
}
final class WordGameFailure extends WordGameState {
  final String message;
  WordGameFailure(this.message);
}