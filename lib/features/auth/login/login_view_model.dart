import 'package:flutter/material.dart';
import 'package:ongi_app/core/di/service_locator.dart';
import 'package:ongi_app/data/dto/request/login_session_request_dto.dart';
import 'package:ongi_app/data/services/auth_service.dart';
import 'package:ongi_app/data/services/auth_session.dart';

class LoginViewModel extends ChangeNotifier {
  final _authService = getIt<AuthService>();
  final _authSession = getIt<AuthSession>();

  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get canLogin =>
      idController.text.isNotEmpty && passwordController.text.isNotEmpty;

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login({required VoidCallback onSuccess}) async {
    if (!canLogin) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.createLoginSession(
        LoginSessionRequestDto(
          loginId: idController.text.trim(),
          password: passwordController.text,
        ),
      );
      _authSession.setLoginSessionToken(result.loginSessionToken);
      onSuccess();
    } catch (e) {
      _errorMessage = '아이디 또는 비밀번호가 올바르지 않습니다.';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
