import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ongi_app/data/dto/request/signup_request_dto.dart';
import 'package:ongi_app/data/network/api_exception.dart';
import 'package:ongi_app/data/services/auth_service.dart';

AuthService get _authService => GetIt.instance<AuthService>();

class SignupViewModel extends ChangeNotifier {
  SignupViewModel() {
    phoneController.addListener(notifyListeners);
    verificationCodeController.addListener(notifyListeners);
    nameController.addListener(notifyListeners);
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
  final TextEditingController nameController = TextEditingController();
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

  // 전화번호 인증 상태
  bool _isCodeSent = false;
  bool _isSendingCode = false;
  bool _isPhoneVerified = false;
  bool _isVerifyingPhone = false;
  String? _phoneVerifyMessage;

  bool get isCodeSent => _isCodeSent;
  bool get isSendingCode => _isSendingCode;
  bool get isPhoneVerified => _isPhoneVerified;
  bool get isVerifyingPhone => _isVerifyingPhone;
  String? get phoneVerifyMessage => _phoneVerifyMessage;

  bool get canSendCode => phoneController.text.replaceAll('-', '').length == 11;

  // 아이디 중복 확인 상태
  bool? _isIdAvailable;
  bool _isCheckingId = false;
  String? _idCheckMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool? get isIdAvailable => _isIdAvailable;
  bool get isCheckingId => _isCheckingId;
  String? get idCheckMessage => _idCheckMessage;

  Future<void> sendVerificationCode() async {
    final phone = phoneController.text.trim();
    if (!canSendCode) return;

    _isSendingCode = true;
    _isCodeSent = false;
    _phoneVerifyMessage = null;
    _isPhoneVerified = false;
    notifyListeners();

    try {
      await _authService.sendVerificationCode(phone);
      _isCodeSent = true;
    } on ApiException catch (e) {
      _phoneVerifyMessage = e.message;
    } catch (_) {
      _phoneVerifyMessage = '인증번호 발송에 실패했습니다. 다시 시도해주세요.';
    } finally {
      _isSendingCode = false;
      notifyListeners();
    }
  }

  Future<void> verifyPhone() async {
    final phone = phoneController.text.trim();
    final code = verificationCodeController.text.trim();
    if (phone.isEmpty || code.isEmpty) return;

    _isVerifyingPhone = true;
    _phoneVerifyMessage = null;
    _isPhoneVerified = false;
    notifyListeners();

    try {
      await _authService.verifyPhone(phone, code);
      _isPhoneVerified = true;
      _phoneVerifyMessage = '인증이 완료되었습니다.';
    } on ApiException catch (e) {
      _phoneVerifyMessage = e.message;
    } catch (_) {
      _phoneVerifyMessage = '인증 확인에 실패했습니다. 다시 시도해주세요.';
    } finally {
      _isVerifyingPhone = false;
      notifyListeners();
    }
  }

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
  bool get canProceedFromPhone => _isPhoneVerified;

  // Step 2 유효성 — 아이디 중복 확인 통과 필요
  bool get canProceedFromAccountInfo =>
      nameController.text.isNotEmpty &&
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
      await _authService.signup(
        SignupRequestDto(
          loginId: idController.text.trim(),
          password: passwordController.text,
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
          elder: ElderDto(
            name: elderlyNameController.text.trim(),
            age: int.parse(elderlyAgeController.text.trim()),
            phone: elderlyPhoneController.text.trim(),
            relationship: elderlyRelationController.text.trim(),
          ),
        ),
      );
      onSuccess();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    } catch (_) {
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
    nameController.removeListener(notifyListeners);
    idController.removeListener(_onIdChanged);
    passwordController.removeListener(notifyListeners);
    confirmPasswordController.removeListener(notifyListeners);
    elderlyNameController.removeListener(notifyListeners);
    elderlyAgeController.removeListener(notifyListeners);
    elderlyRelationController.removeListener(notifyListeners);
    elderlyPhoneController.removeListener(notifyListeners);

    phoneController.dispose();
    verificationCodeController.dispose();
    nameController.dispose();
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
