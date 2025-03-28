class RegisterResponseDTO {
  final String userId;
  final String email;
  final DateTime createdAt;

  RegisterResponseDTO({
    required this.userId,
    required this.email,
    required this.createdAt,
  });

  factory RegisterResponseDTO.fromJson(Map<String, dynamic> json) {
    return RegisterResponseDTO(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class LoginResponseDTO {
  final String token;

  LoginResponseDTO({
    required this.token,
  });

  factory LoginResponseDTO.fromJson(Map<String, dynamic> json) {
    return LoginResponseDTO(
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}
