import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ongi_app/data/network/api_exception.dart';
import 'package:ongi_app/data/services/auth_service.dart';

class SignupViewModel extends ChangeNotifier {
  SignupViewModel() {
    phoneController.addListener(notifyListeners);
    verificationCodeController.addListener(notifyListeners);
    idController.addListener(_onIdChanged);
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

  // 아이디 중복 확인 상태
  bool? _isIdAvailable;
  bool _isCheckingId = false;
  String? _idCheckMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool? get isIdAvailable => _isIdAvailable;
  bool get isCheckingId => _isCheckingId;
  String? get idCheckMessage => _idCheckMessage;

  void _onIdChanged() {
    if (_isIdAvailable != null || _idCheckMessage != null) {
      _isIdAvailable = null;
      _idCheckMessage = null;
    }
    notifyListeners();
  }

  Future<void> checkId() async {
    final loginId = idController.text.trim();
    if (loginId.isEmpty) return;

    _isCheckingId = true;
    _idCheckMessage = null;
    _isIdAvailable = null;
    notifyListeners();

    try {
      final available = await GetIt.instance<AuthService>().checkId(loginId);
      _isIdAvailable = available;
      _idCheckMessage = available ? '사용 가능한 아이디입니다.' : '이미 사용 중인 아이디입니다.';
    } on ApiException catch (e) {
      _isIdAvailable = false;
      _idCheckMessage = e.message;
    } catch (_) {
      _isIdAvailable = false;
      _idCheckMessage = '아이디 확인에 실패했습니다. 다시 시도해주세요.';
    } finally {
      _isCheckingId = false;
      notifyListeners();
    }
  }

  // Step 1 유효성
  bool get canProceedFromPhone =>
      phoneController.text.isNotEmpty &&
      verificationCodeController.text.isNotEmpty;

  // Step 2 유효성 — 아이디 중복 확인 통과 필요
  bool get canProceedFromAccountInfo =>
      idController.text.isNotEmpty &&
      _isIdAvailable == true &&
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
    idController.removeListener(_onIdChanged);
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
