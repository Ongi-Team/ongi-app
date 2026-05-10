import 'dart:core';

abstract class Apis {
  Apis._();

  /// 변수명은 동사+목적어로 명명한다.
  /// baseUrl 끝에 /가 있어서, 여기서는 맨 앞에 /을 빼고 기입한다.

  /// 토큰 관련 api
  static const String postSignup = "auth/signup";
  static const String reissueToken = "auth/reissue";

  /// 로그인 관련 api
  static const String getCheckId = "auth/check-id";
  static const String postPhoneVerify = "auth/phone/verify";
  static const String sendPhoneNumber = "auth/phone/send";
}
