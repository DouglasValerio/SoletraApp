abstract interface class StorageService {
  Future<void> saveString(String key, String value);
  Future<String> getString(String key);
  Future<String> getSessionId();
}
