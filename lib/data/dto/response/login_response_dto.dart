class LoginResponseDto {
  final String accessToken;
  final String refreshToken;
  final String loginMode;
  final MemberResponseDto? member;
  final ElderResponseDto? elder;

  const LoginResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.loginMode,
    this.member,
    this.elder,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      loginMode: json['loginMode'] as String,
      member: json['member'] == null
          ? null
          : MemberResponseDto.fromJson(json['member'] as Map<String, dynamic>),
      elder: json['elder'] == null
          ? null
          : ElderResponseDto.fromJson(json['elder'] as Map<String, dynamic>),
    );
  }
}

class MemberResponseDto {
  final int memberId;
  final String name;
  final String phone;

  const MemberResponseDto({
    required this.memberId,
    required this.name,
    required this.phone,
  });

  factory MemberResponseDto.fromJson(Map<String, dynamic> json) {
    return MemberResponseDto(
      memberId: json['memberId'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
    );
  }
}

class ElderResponseDto {
  final int elderId;
  final String name;
  final int age;
  final String relationship;

  const ElderResponseDto({
    required this.elderId,
    required this.name,
    required this.age,
    required this.relationship,
  });

  factory ElderResponseDto.fromJson(Map<String, dynamic> json) {
    return ElderResponseDto(
      elderId: json['elderId'] as int,
      name: json['name'] as String,
      age: json['age'] as int,
      relationship: json['relationship'] as String,
    );
  }
}
