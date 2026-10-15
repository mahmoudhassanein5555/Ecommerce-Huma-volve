import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../domain/entities/auth_session.dart';
import '../domain/usecases/login.dart';
import '../domain/usecases/sign_up.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required this.loginUseCase, required this.signUpUseCase});

  final Login loginUseCase;
  final SignUp signUpUseCase;

  bool isLoading = false;
  String? errorMessage;
  AuthSession? session;

  Future<bool> login({required String email, required String password}) async {
    if (isLoading) return false;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      session = await loginUseCase(email: email.trim(), password: password);
      return true;
    } on DioException catch (error) {
      errorMessage = _messageFrom(error);
    } on FormatException catch (error) {
      errorMessage = error.message;
    } catch (error) {
      errorMessage = 'Unable to log in: $error';
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (isLoading) return false;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await signUpUseCase(
        name: name.trim(),
        email: email.trim(),
        password: password,
      );
      return true;
    } on DioException catch (error) {
      errorMessage = _messageFrom(error);
    } on FormatException catch (error) {
      errorMessage = error.message;
    } catch (error) {
      errorMessage = 'Unable to create your account: $error';
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return false;
  }

  String _messageFrom(DioException error) {
    final responseMessage = error.response?.data;
    if (responseMessage is Map<String, dynamic>) {
      final message = responseMessage['message'];
      if (message is String && message.isNotEmpty) return message;
      if (message is List && message.isNotEmpty) {
        return message.join('\n');
      }
    }
    return error.message ?? 'Could not connect to the authentication service.';
  }
}
