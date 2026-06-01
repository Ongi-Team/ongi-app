import 'package:flutter/foundation.dart';

class AuthRedirectNotifier {
  AuthRedirectNotifier._();

  static final ValueNotifier<int> signal = ValueNotifier<int>(0);

  static void notifyAuthChanged() {
    signal.value++;
  }
}
