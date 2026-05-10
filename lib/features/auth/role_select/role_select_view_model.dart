import 'package:flutter/material.dart';
import 'package:ongi_app/core/di/service_locator.dart';
import 'package:ongi_app/core/enums/user_role.dart';
import 'package:ongi_app/data/repositories/secure_storage_repository.dart';

class RoleSelectViewModel extends ChangeNotifier {
  final _storage = getIt<SecureStorageRepository>();

  UserRole? _selectedRole;

  UserRole? get selectedRole => _selectedRole;

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

    await _storage.saveRole(_selectedRole!.name);

    switch (_selectedRole!) {
      case UserRole.GUARDIAN:
        onGuardian();
      case UserRole.ELDER:
        onElder();
    }
  }
}
