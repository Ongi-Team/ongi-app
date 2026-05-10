import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:ongi_app/core/di/service_locator.dart';
import 'package:ongi_app/data/repositories/secure_storage_repository.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;
  debugPrint('[FCM] notification permission status: $status');

  if (status.isDenied) {
    final result = await Permission.notification.request();
    debugPrint('[FCM] permission request result: $result');
    if (result.isGranted) {
      await _fetchAndSaveFcmToken();
    }
  } else if (status.isGranted) {
    await _fetchAndSaveFcmToken();
  }
}

Future<void> _fetchAndSaveFcmToken() async {
  if (Platform.isIOS) {
    String? apnsToken;
    for (int i = 0; i < 5; i++) {
      apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      debugPrint('[FCM] APNS token attempt ${i + 1}: $apnsToken');
      if (apnsToken != null) break;
      await Future.delayed(const Duration(seconds: 1));
    }
    if (apnsToken == null) {
      debugPrint('[FCM] APNS token not available, skipping FCM token fetch');
      return;
    }
  }

  final token = await FirebaseMessaging.instance.getToken();
  debugPrint('[FCM] FCM token: $token');
  if (token != null) {
    await getIt<SecureStorageRepository>().saveFcmToken(token);
    debugPrint('[FCM] token saved');
  }
}
