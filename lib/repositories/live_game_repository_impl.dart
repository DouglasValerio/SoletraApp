
import 'package:soletra_app/external/pub_sub/pub_nub_service.dart';
import 'package:soletra_app/models/word_model.dart';
import 'package:soletra_app/repositories/live_game_repository.dart';

const id = '25b1788f-3523-4a6c-a3d6-f2ab5feb213b';

class LiveGameRepositoryImpl implements LiveGameRepository {
  final PubNubService pubNubService;
  LiveGameRepositoryImpl({
    required this.pubNubService,
  });

  @override
  Stream<WordModel> liveGame() {
    return pubNubService
        .liveGame()
        .where((event) => event.uuid.value != id)
        .map((event) {
      return WordModel.fromJson(event.payload);
    });
  }

  @override
  void sendWord(WordModel word) {
    try {
      pubNubService.sendEvent(
        'soletra',
        word.toJson(),
      );
    } catch (e) {
      return;
    }
  }
}
