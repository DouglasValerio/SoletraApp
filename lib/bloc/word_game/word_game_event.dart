part of 'word_game_bloc.dart';

@immutable
sealed class WordGameEvent {}

final class WordGameStarted extends WordGameEvent {}
final class WordGameSubmitted extends WordGameEvent {
  final String word;

  WordGameSubmitted({required this.word});
}
final class WordGameScoreFromPartner extends WordGameEvent {
  final String word;
  
  WordGameScoreFromPartner({required this.word});
}
