part of 'word_game_bloc.dart';

@immutable
sealed class WordGameState {}

final class WordGameInitial extends WordGameState {}
final class WordGameLoading extends WordGameState {}
final class WordGameSuccess extends WordGameState {
  final List<WordModel> wordGameModel;
  final int index;

  WordGameSuccess({required this.wordGameModel ,required this.index});
}
class WordGameFailedAttempt extends WordGameState {
  final List<WordModel> wordGameModel;

  WordGameFailedAttempt({required this.wordGameModel});
}
final class WordGameFailure extends WordGameState {
  final String message;
  WordGameFailure(this.message);
}