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

class GoogleAuthRequestDTO {
  final String email;
  final String name;
  final String? photoUrl;
  final String googleId;
  final String? idToken;

  GoogleAuthRequestDTO({
    required this.email,
    required this.name,
    this.photoUrl,
    required this.googleId,
    this.idToken,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'photo_url': photoUrl,
        'google_id': googleId,
        'id_token': idToken,
      };
}
