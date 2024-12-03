import 'package:soletra_app/models/models.dart';

abstract interface class WordGameRepository {
  Future<WordGameModel> getWordGame();
}