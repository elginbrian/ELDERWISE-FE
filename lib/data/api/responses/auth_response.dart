import 'package:flutter/material.dart';

class RegisterResponseDTO {
  final String userId;
  final String email;
  final DateTime createdAt;

  RegisterResponseDTO({
    required this.userId,
    required this.email,
    required this.createdAt,
  });

  factory RegisterResponseDTO.fromJson(dynamic json) {
    debugPrint('RegisterResponseDTO.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        if (json.containsKey('user_id') &&
            json.containsKey('email') &&
            json.containsKey('created_at')) {
          return RegisterResponseDTO(
            userId: json['user_id'] as String,
            email: json['email'] as String,
            createdAt: DateTime.parse(json['created_at'] as String),
          );
        } else {
          throw FormatException(
              'Missing required fields in response map: $json');
        }
      } else {
        throw FormatException(
            'Unsupported JSON format for registration: $json');
      }
    } catch (e) {
      debugPrint('Error in RegisterResponseDTO.fromJson: $e');
      rethrow;
    }
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

  factory LoginResponseDTO.fromJson(dynamic json) {
    debugPrint('LoginResponseDTO.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map) {
        if (json.containsKey('token') && json['token'] is String) {
          return LoginResponseDTO(token: json['token'] as String);
        } else {
          throw FormatException('Invalid token format in response map: $json');
        }
      } else if (json is String) {
        return LoginResponseDTO(token: json);
      } else {
        throw FormatException('Unsupported JSON format for token: $json');
      }
    } catch (e) {
      debugPrint('Error in LoginResponseDTO.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}
