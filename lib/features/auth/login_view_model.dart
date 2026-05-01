import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 로그인 버튼 활성화 조건
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
      // TODO: 실제 로그인 API 호출
      await Future.delayed(const Duration(seconds: 1)); // 임시 딜레이

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
