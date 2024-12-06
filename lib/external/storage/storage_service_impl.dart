import 'package:hive_flutter/hive_flutter.dart';
import 'package:soletra_app/external/storage/storage_service.dart';
import 'package:uuid/uuid.dart';

class StorageServiceImpl implements StorageService {
  final Box<dynamic> box;

  const StorageServiceImpl({required this.box});

  
  @override
  Future<String> getSessionId() async{
   final cachedId = await _getString('user_session');
    if(cachedId.isEmpty){
      final newId = const Uuid().v4();
      await _saveString('user_session', newId);
      return newId;
    }
    return cachedId;
  }

   Future<String> _getString(String key) async {
    try {
      return await box.get(key, defaultValue: '') as String;
    } catch (e) {
      return '';
    }
  }

  Future<void> _saveString(String key, String value) async {
    try {
      return await box.put(key, value);
    } catch (e) {
      return;
    }
  }
}
