import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/storage/token_storage.dart';
import '../models/sign_up_request_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// ViewModel for the auth flow: login, sign up, session restore, logout.
/// Screens call these methods and react to [isLoading] / the returned error.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authService, this._tokenStorage);

  final AuthService _authService;
  final TokenStorage _tokenStorage;

  bool _isLoading = false;
  UserModel? _user;

  bool get isLoading => _isLoading;
  UserModel? get user => _user;
  bool get isLoggedIn => _tokenStorage.hasToken;

  /// Returns an error message, or null on success.
  Future<String?> login({
    required String email,
    required String password,
  }) {
    return _run(() async {
      final tokens = await _authService.login(email: email, password: password);
      await _tokenStorage.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      _user = await _authService.getProfile();
    });
  }

  /// Creates the account, then logs in so the user lands on Home directly.
  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return _run(() async {
      await _authService.signUp(
        SignUpRequestModel(name: name, email: email, password: password),
      );
      final tokens = await _authService.login(email: email, password: password);
      await _tokenStorage.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      _user = await _authService.getProfile();
    });
  }

  /// Called on app start: true if a saved token is still valid.
  Future<bool> restoreSession() async {
    if (!_tokenStorage.hasToken) return false;
    try {
      _user = await _authService.getProfile();
      notifyListeners();
      return true;
    } on AppException {
      await _tokenStorage.clear(); // expired / invalid token
      return false;
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clear();
    _user = null;
    notifyListeners();
  }

  /// Shared loading + error handling for user actions.
  Future<String?> _run(Future<void> Function() action) async {
    if (_isLoading) return null;
    _isLoading = true;
    notifyListeners();
    try {
      await action();
      return null;
    } on AppException catch (e) {
      return e.message;
    } catch (_) {
      return 'Something went wrong. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
