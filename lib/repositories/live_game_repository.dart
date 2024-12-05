import 'package:soletra_app/models/models.dart';

abstract interface class LiveGameRepository {
  Future<Stream<WordModel>> liveGame();
  void sendWord(WordModel word);
}