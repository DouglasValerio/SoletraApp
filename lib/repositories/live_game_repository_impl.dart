import 'package:pubnub/pubnub.dart';
import 'package:soletra_app/config/env.dart';
import 'package:soletra_app/models/word_model.dart';
import 'package:soletra_app/repositories/live_game_repository.dart';

const id = '25b1788f-3523-4a6c-a3d6-f2ab5feb213b';

class LiveGameRepositoryImpl implements LiveGameRepository {
  final pubnub = PubNub(
      defaultKeyset: Keyset(
          subscribeKey: AppEnv.pubNubSubscribeKey,
          publishKey: AppEnv.pubNubPublishKey,
          userId: const UserId(id)));

  @override
  Stream<WordModel> liveGame() {
    return pubnub
        .subscribe(channels: {'soletra'})
        .messages
        .where((event) => event.uuid.value != id)
        .map((event) {
          return WordModel.fromJson(event.payload);
        });
  }

  @override
  void sendWord(WordModel word) {
    try {
      pubnub.publish(
        'soletra',
        word.toJson(),
      );
    } catch (e) {
      return;
    }
  }
}
