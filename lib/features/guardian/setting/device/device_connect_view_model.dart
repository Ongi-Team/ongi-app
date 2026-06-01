import 'package:flutter/material.dart';

class DeviceConnectViewModel extends ChangeNotifier {
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isConnecting = false;

  bool get isConnecting => _isConnecting;

  bool get canConnect =>
      ssidController.text.trim().isNotEmpty &&
      passwordController.text.trim().isNotEmpty &&
      !_isConnecting;

  void onInputChanged() {
    notifyListeners();
  }

  Future<void> connectDevice() async {
    if (!canConnect) return;

    _isConnecting = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 700));

    _isConnecting = false;
    notifyListeners();
  }

  @override
  void dispose() {
    ssidController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
