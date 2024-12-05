import 'package:pubnub/pubnub.dart';
import 'package:soletra_app/config/env.dart';
import 'package:soletra_app/external/pub_sub/pub_nub_service.dart';

const id = '25b1788f-3523-4a6c-a3d6-f2ab5feb213b';

class PubNubServiceImpl implements PubNubService {
  final pubnub = PubNub(
      defaultKeyset: Keyset(
          subscribeKey: AppEnv.pubNubSubscribeKey,
          publishKey: AppEnv.pubNubPublishKey,
          userId: const UserId(id)));

  @override
  Stream<Envelope> liveGame() {
    return pubnub.subscribe(channels: {'soletra'}).messages;
  }

  @override
  void sendEvent(String channel, message) {
    pubnub.publish(
      channel,
      message,
    );
  }
}
