class RegisterRequestDTO {
  final String email;
  final String password;

  RegisterRequestDTO({
    required this.email,
    required this.password,
  });

  factory RegisterRequestDTO.fromJson(Map<String, dynamic> json) {
    return RegisterRequestDTO(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginRequestDTO {
  final String email;
  final String password;

  LoginRequestDTO({
    required this.email,
    required this.password,
  });

  factory LoginRequestDTO.fromJson(Map<String, dynamic> json) {
    return LoginRequestDTO(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
