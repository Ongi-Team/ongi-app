class LoginRequestDto {
  final String loginId;
  final String password;
  final String loginMode;
  final String fcmToken;
  final String osType;

  const LoginRequestDto({
    required this.loginId,
    required this.password,
    required this.loginMode,
    required this.fcmToken,
    required this.osType,
  });

  Map<String, dynamic> toJson() => {
        'loginId': loginId,
        'password': password,
        'loginMode': loginMode,
        'fcmToken': fcmToken,
        'osType': osType,
      };
}
