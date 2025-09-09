import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _sotorage = FlutterSecureStorage();

  Future<void> saveToken(String key, String token)async{
    await _sotorage.write(key: key, value: token);
  }

  Future<String?> getToken(String key)async{
    return await _sotorage.read(key: key);
  }

  Future<void> deleteToken(String key)async{
    await _sotorage.delete(key: key);
  }

  Future<void> clearAll()async{
    await _sotorage.deleteAll();
  }

  Future<void> saveUserData(String userData)async{
    await _sotorage.write(key: "user_data", value: userData);
  }

  Future<String?> getUserData()async{
    return await _sotorage.read(key: "user_data");
  }
}