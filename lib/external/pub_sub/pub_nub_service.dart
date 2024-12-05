import 'package:pubnub/pubnub.dart';

abstract interface class PubNubService {
  Stream<Envelope> liveGame(String sessionId);
  void sendEvent(String sessionId, String channel,
  dynamic message,);
}