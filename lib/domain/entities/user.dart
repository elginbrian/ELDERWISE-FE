class User {
  final String userId;
  final String email;
  final String password;
  final DateTime createdAt;

  User({
    required this.userId,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'password': password,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
