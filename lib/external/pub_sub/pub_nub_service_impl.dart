import 'package:pubnub/pubnub.dart';
import 'package:soletra_app/config/env.dart';
import 'package:soletra_app/external/pub_sub/pub_nub_service.dart';

class PubNubServiceImpl implements PubNubService {
  PubNub? pubnub;

  @override
  Stream<Envelope> liveGame(String sessionId) {
    pubnub ??= _createPubNub(sessionId);
    if (pubnub == null) {
      throw Exception('PubNub was not initialized');
    }
    return pubnub!.subscribe(channels: {'soletra'}).messages;
  }

  @override
  void sendEvent(String sessionId, String channel, message) {
    pubnub ??= _createPubNub(sessionId);
    if (pubnub == null) {
      throw Exception('PubNub was not initialized');
    }
    pubnub!.publish(
      channel,
      message,
    );
  }

  PubNub _createPubNub(String id) {
    return PubNub(
      defaultKeyset: Keyset(
        subscribeKey: AppEnv.pubNubSubscribeKey,
        publishKey: AppEnv.pubNubPublishKey,
        userId: UserId(id),
      ),
    );
  }
}
