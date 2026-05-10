import 'dart:core';

abstract class Apis {
  Apis._();

  /// 변수명은 동사+목적어로 명명한다.
  /// baseUrl 끝에 /가 있어서, 여기서는 맨 앞에 /을 빼고 기입한다.

  /// 토큰 관련 api
  static const String postSignup = "api/auth/signup";
  static const String reissueToken = "auth/reissue";

  /// 로그인 관련 api
  static const String postLogin = "api/auth/login";
  static const String getCheckId = "api/auth/check-id";
  static const String postPhoneVerify = "api/auth/phone/verify";
  static const String sendPhoneNumber = "api/auth/phone/send";
}
