import 'package:flutter/material.dart';
import 'package:ongi_app/core/enums/user_role.dart';

class RoleSelectViewModel extends ChangeNotifier {
  UserRole? _selectedRole;

  UserRole? get selectedRole => _selectedRole;

  void selectRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  void confirm({
    required BuildContext context,
    required VoidCallback onGuardian,
    required VoidCallback onElder,
  }) {
    if (_selectedRole == null) return;

    switch (_selectedRole!) {
      case UserRole.GUARDIAN:
        onGuardian();
      case UserRole.ELDER:
        onElder();
    }
  }
}
