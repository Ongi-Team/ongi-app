class LoginRequestDto {
  final String loginSessionToken;
  final String loginMode;
  final String fcmToken;
  final String osType;

  const LoginRequestDto({
    required this.loginSessionToken,
    required this.loginMode,
    required this.fcmToken,
    required this.osType,
  });

  Map<String, dynamic> toJson() => {
        'loginSessionToken': loginSessionToken,
        'loginMode': loginMode,
        'fcmToken': fcmToken,
        'osType': osType,
      };
}
