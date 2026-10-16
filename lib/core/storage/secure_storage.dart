import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class secureStorage{

  static final storage = FlutterSecureStorage();
 static Future <void> saveAccessToken(String? token)async{
    await storage.write(key: 'access-token', value: 'token');
  }

 static Future <void> saveRefreshToken(String? token)async{
    await storage.write(key: 'refresh-token', value: 'token');
  }
  static Future <String?> getAccessToken()async{
   return await storage.read(key: 'access-token');
  }
  static Future <String?> getRefreshToken()async{
    return await storage.read(key: 'refresh-token');
  }
  Future <void> deleteTokens()async{
   await storage.deleteAll();
  }
}