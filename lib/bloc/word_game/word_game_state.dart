// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'word_game_bloc.dart';

@immutable
sealed class WordGameState {}

class WordGameInitial extends WordGameState {}

class WordGameLoading extends WordGameState {}

class WordGameSuccess extends WordGameState {
  final List<WordModel> wordGameModel;
  final int index;
  final String message;

  WordGameSuccess(
      {required this.wordGameModel,
      required this.index,
      this.message = "Palavra encontrada"});
}

class WordFoundByPartner extends WordGameSuccess {
  WordFoundByPartner(
      {required super.wordGameModel,
      required super.index,
      super.message = "Palavra encontrada pelo seu parceiro"});
}

class WordFindByPlayer extends WordGameSuccess {
  WordFindByPlayer(
      {required super.wordGameModel,
      required super.index,
      super.message = "Palavra encontrada"});
}
class WordAlreadyFound extends WordGameSuccess {
  WordAlreadyFound(
      {required super.wordGameModel,
      required super.index,
      super.message = "Palavra já encontrada"});
}

class WordNotIncludedOnGame extends WordGameSuccess {
  WordNotIncludedOnGame(
      {required super.wordGameModel, super.message = "Palavra não encontrada"})
      : super(
          index: -1,
        );
}

class WordGameFailure extends WordGameState {
  final String message;
  WordGameFailure(this.message);
}
