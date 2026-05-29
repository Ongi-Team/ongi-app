class LoginSessionRequestDto {
  final String loginId;
  final String password;

  const LoginSessionRequestDto({
    required this.loginId,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'loginId': loginId,
        'password': password,
      };
}
