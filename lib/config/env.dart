final class AppEnv {
  static const pubNubPublishKey = String.fromEnvironment('PUBNUB_PUBLISH_KEY');
  static const pubNubSubscribeKey = String.fromEnvironment('PUBNUB_SUBSCRIBE_KEY');

  static const apiUrl= String.fromEnvironment('API_URL');
}