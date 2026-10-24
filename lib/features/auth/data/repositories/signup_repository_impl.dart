import '../../domain/entities/signup_entity.dart';
import '../../domain/repositories/signup_repository.dart';
import '../data_sources/signup_remote_data_source.dart';
import '../models/signup_req_model.dart';

class SignupRepositoryImpl implements SignupRepository {
  final SignupRemoteDataSource remoteDataSource;

  SignupRepositoryImpl(this.remoteDataSource);

  @override
  Future<SignupEntity> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final model = await remoteDataSource.signup(
      signupReqModel: SignupReqModel(name: name, email: email, password: password),
    );

    return SignupEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      role: model.role,
      avatar: model.avatar,
    );
  }
}
