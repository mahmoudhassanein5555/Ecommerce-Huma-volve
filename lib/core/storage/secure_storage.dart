import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
   static final storage = FlutterSecureStorage();
 static Future <void> saveAccesstoken(String?token)async{
    await storage.write(key: 'access_token', value: token);
  }
 static Future <void> Saverefreshtoken(String?token)async{
    await storage.write(key: 'refresh_token', value: token);
  }
  static Future<String?> getAccesstoken()async{
    return await storage.read(key: 'access_token');
  }
  static Future<String?> getrefreshtoken()async{
    return await storage.read(key: 'refresh_token');
  }
   static Future <void> deleteTokens()async{
    await storage.deleteAll();
  }
  

  
}