import 'package:flutter/material.dart';

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

  factory User.fromJson(dynamic json) {
    debugPrint('User.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        final requiredFields = ['user_id', 'email', 'password', 'created_at'];

        for (final field in requiredFields) {
          if (!json.containsKey(field)) {
            throw FormatException(
                'Missing required field: $field in user data: $json');
          }
        }

        return User(
          userId: json['user_id'] as String,
          email: json['email'] as String,
          password: json['password'] as String,
          createdAt: DateTime.parse(json['created_at'] as String),
        );
      } else {
        throw FormatException('Unsupported JSON format for user: $json');
      }
    } catch (e) {
      debugPrint('Error in User.fromJson: $e');
      rethrow;
    }
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
