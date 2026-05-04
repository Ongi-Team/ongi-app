import 'package:flutter/material.dart';

class SignupViewModel extends ChangeNotifier {
  SignupViewModel() {
    phoneController.addListener(notifyListeners);
    verificationCodeController.addListener(notifyListeners);
    idController.addListener(notifyListeners);
    passwordController.addListener(notifyListeners);
    confirmPasswordController.addListener(notifyListeners);
  }

  // Step 1: 전화번호 인증
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController verificationCodeController =
      TextEditingController();

  // Step 2: 계정 정보
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get canProceedFromPhone =>
      phoneController.text.isNotEmpty &&
      verificationCodeController.text.isNotEmpty;

  bool get canSubmitAccountInfo =>
      idController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      confirmPasswordController.text.isNotEmpty &&
      passwordController.text == confirmPasswordController.text;

  String? get passwordMatchError {
    if (confirmPasswordController.text.isNotEmpty &&
        passwordController.text != confirmPasswordController.text) {
      return '비밀번호가 일치하지 않습니다.';
    }
    return null;
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<void> submitSignup({required VoidCallback onSuccess}) async {
    if (!canSubmitAccountInfo) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: 회원가입 API 호출
      await Future.delayed(const Duration(seconds: 1));
      onSuccess();
    } catch (e) {
      _errorMessage = '회원가입에 실패했습니다. 다시 시도해주세요.';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    phoneController.removeListener(notifyListeners);
    verificationCodeController.removeListener(notifyListeners);
    idController.removeListener(notifyListeners);
    passwordController.removeListener(notifyListeners);
    confirmPasswordController.removeListener(notifyListeners);

    phoneController.dispose();
    verificationCodeController.dispose();
    idController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
