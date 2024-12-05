import 'package:soletra_app/external/http/dio_client.dart';
import 'package:soletra_app/models/letters_model.dart';
import 'package:soletra_app/repositories/word_game_repository.dart';

import '../models/models.dart';

class WordGameRepositoryImpl implements WordGameRepository {
  final DioClient _dioClient;

  WordGameRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;
  @override
  Future<List<WordModel>> getWordGame() async {
    try {
      final response = await _dioClient.get('/game');
      final data = response.data as List<dynamic>;
      final words = data.map((e) => WordModel.fromMap(e)).toList();
      return words;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<LettersModel> getAvailableLetters() async {
    try {
      final response = await _dioClient.get('/game/letters');
      final data = response.data as Map<String, dynamic>;
      final letters = LettersModel.fromMap(data);
      return letters;
    } catch (e) {
      const letters = LettersModel(
          centralLetter: 'c', outerLetters: ['a', 'd', 'n', 'o', 't', 'u']);
      return letters;
    }
  }
}
