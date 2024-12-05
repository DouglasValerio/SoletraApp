import 'package:pubnub/pubnub.dart';

abstract interface class PubNubService {
  Stream<Envelope> liveGame();
  void sendEvent(String channel,
  dynamic message,);
}