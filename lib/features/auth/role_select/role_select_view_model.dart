import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ongi_app/core/di/service_locator.dart';
import 'package:ongi_app/core/enums/user_role.dart';
import 'package:ongi_app/data/dto/request/login_request_dto.dart';
import 'package:ongi_app/data/repositories/secure_storage_repository.dart';
import 'package:ongi_app/data/services/auth_service.dart';
import 'package:ongi_app/data/services/auth_session.dart';

class RoleSelectViewModel extends ChangeNotifier {
  final _authService = getIt<AuthService>();
  final _authSession = getIt<AuthSession>();
  final _storage = getIt<SecureStorageRepository>();

  UserRole? _selectedRole;
  bool _isLoading = false;
  String? _errorMessage;

  UserRole? get selectedRole => _selectedRole;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void selectRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future<void> confirm({
    required BuildContext context,
    required VoidCallback onGuardian,
    required VoidCallback onElder,
  }) async {
    if (_selectedRole == null) return;

    final loginSessionToken = _authSession.loginSessionToken;
    if (loginSessionToken == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fcmToken = await _storage.readFcmToken() ?? '';
      final osType = Platform.isIOS ? 'IOS' : 'ANDROID';

      await _authService.login(LoginRequestDto(
        loginSessionToken: loginSessionToken,
        loginMode: _selectedRole!.name,
        fcmToken: fcmToken,
        osType: osType,
      ));

      _authSession.clear();

      switch (_selectedRole!) {
        case UserRole.GUARDIAN:
          onGuardian();
        case UserRole.ELDER:
          onElder();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
