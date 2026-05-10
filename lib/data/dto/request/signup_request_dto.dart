class ElderDto {
  final String name;
  final int age;
  final String phone;
  final String relationship;

  const ElderDto({
    required this.name,
    required this.age,
    required this.phone,
    required this.relationship,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'phone': phone,
        'relationship': relationship,
      };
}

class SignupRequestDto {
  final String loginId;
  final String password;
  final String name;
  final String phone;
  final ElderDto elder;

  const SignupRequestDto({
    required this.loginId,
    required this.password,
    required this.name,
    required this.phone,
    required this.elder,
  });

  Map<String, dynamic> toJson() => {
        'loginId': loginId,
        'password': password,
        'name': name,
        'phone': phone,
        'elder': elder.toJson(),
      };
}
