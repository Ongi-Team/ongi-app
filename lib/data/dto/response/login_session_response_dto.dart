class LoginSessionResponseDto {
  final String loginSessionToken;

  const LoginSessionResponseDto({
    required this.loginSessionToken,
  });

  factory LoginSessionResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginSessionResponseDto(
      loginSessionToken: json['loginSessionToken'] as String,
    );
  }
}
