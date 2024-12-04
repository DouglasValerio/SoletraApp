import 'package:soletra_app/models/letters_model.dart';
import 'package:soletra_app/models/models.dart';

abstract interface class WordGameRepository {
  Future<List<WordModel>> getWordGame();
  Future<LettersModel> getAvailableLetters();
}