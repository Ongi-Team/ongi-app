import 'package:flutter/foundation.dart';

class ElderHomeRefreshNotifier {
  ElderHomeRefreshNotifier._();

  static final ValueNotifier<int> signal = ValueNotifier<int>(0);

  static void refresh() {
    signal.value++;
  }
}
