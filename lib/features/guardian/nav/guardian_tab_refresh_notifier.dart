import 'package:flutter/foundation.dart';

class GuardianTabRefreshNotifier {
  GuardianTabRefreshNotifier._();

  static final ValueNotifier<int> homeSignal = ValueNotifier<int>(0);
  static final ValueNotifier<int> scheduleSignal = ValueNotifier<int>(0);
  static final ValueNotifier<int> settingSignal = ValueNotifier<int>(0);

  static void refresh(int index) {
    switch (index) {
      case 0:
        homeSignal.value++;
        break;
      case 1:
        scheduleSignal.value++;
        break;
      case 2:
        settingSignal.value++;
        break;
    }
  }
}
