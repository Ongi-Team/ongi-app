import 'package:flutter/material.dart';

class SignupViewModel extends ChangeNotifier {
  SignupViewModel() {
    phoneController.addListener(notifyListeners);
    verificationCodeController.addListener(notifyListeners);
    idController.addListener(notifyListeners);
    passwordController.addListener(notifyListeners);
    confirmPasswordController.addListener(notifyListeners);
    elderlyNameController.addListener(notifyListeners);
    elderlyAgeController.addListener(notifyListeners);
    elderlyRelationController.addListener(notifyListeners);
    elderlyPhoneController.addListener(notifyListeners);
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

  // Step 3: 어르신 정보
  final TextEditingController elderlyNameController = TextEditingController();
  final TextEditingController elderlyAgeController = TextEditingController();
  final TextEditingController elderlyRelationController =
      TextEditingController();
  final TextEditingController elderlyPhoneController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Step 1 유효성
  bool get canProceedFromPhone =>
      phoneController.text.isNotEmpty &&
      verificationCodeController.text.isNotEmpty;

  // Step 2 유효성
  bool get canProceedFromAccountInfo =>
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

  // Step 3 유효성
  bool get canSubmitElderlyInfo =>
      elderlyNameController.text.isNotEmpty &&
      elderlyAgeController.text.isNotEmpty &&
      elderlyRelationController.text.isNotEmpty &&
      elderlyPhoneController.text.isNotEmpty;

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<void> submitSignup({required VoidCallback onSuccess}) async {
    if (!canSubmitElderlyInfo) return;

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
    elderlyNameController.removeListener(notifyListeners);
    elderlyAgeController.removeListener(notifyListeners);
    elderlyRelationController.removeListener(notifyListeners);
    elderlyPhoneController.removeListener(notifyListeners);

    phoneController.dispose();
    verificationCodeController.dispose();
    idController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    elderlyNameController.dispose();
    elderlyAgeController.dispose();
    elderlyRelationController.dispose();
    elderlyPhoneController.dispose();
    super.dispose();
  }
}
