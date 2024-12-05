// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:soletra_app/external/pub_sub/pub_nub_service.dart';
import 'package:soletra_app/external/storage/storage_service.dart';
import 'package:soletra_app/models/word_model.dart';
import 'package:soletra_app/repositories/live_game_repository.dart';

const id = '25b1788f-3523-4a6c-a3d6-f2ab5feb213b';

class LiveGameRepositoryImpl implements LiveGameRepository {
  final PubNubService pubNubService;
  final StorageService storageService;
  LiveGameRepositoryImpl({
    required this.pubNubService,
    required this.storageService,
  });

  @override
  Future<Stream<WordModel>> liveGame() async {
    final sessionId = await storageService.getSessionId();
    return pubNubService
        .liveGame(sessionId)
        .where((event) => event.uuid.value != id)
        .map((event) {
      return WordModel.fromJson(event.payload);
    });
  }

  @override
  void sendWord(WordModel word) async {
    try {
      final sessionId = await storageService.getSessionId();
      pubNubService.sendEvent(
        sessionId,
        'soletra',
        word.toJson(),
      );
    } catch (e) {
      return;
    }
  }
}
