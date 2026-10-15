import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/register_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/login.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/register.dart';
import 'package:ecommerce_app_huma_volve/features/auth/presentation/cubit/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final Login _login;
  final Register _register;
  AuthCubit(this._login, this._register) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await _login(
      loginRequest: LoginRequest(email: email, password: password),
    );
    result.fold((l) => emit(AuthError(l.msg)), (r) => emit(AuthSuccess()));
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await _register(
      registerRequest: RegisterRequest(
        name: name,
        email: email,
        password: password,
      ),
    );
    result.fold((l) => emit(AuthError(l.msg)), (r) => emit(AuthSuccess()));
  }
}
