import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // هنا بيحصل الاتصال بالـ API
    return UserModel(id: '1', name: 'Test User', email: email);
  }
}
