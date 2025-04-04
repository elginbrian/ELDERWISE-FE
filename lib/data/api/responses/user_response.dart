import 'package:elderwise/domain/entities/user.dart';
import 'package:flutter/material.dart';

class UserResponseDTO {
  final User user;

  UserResponseDTO({
    required this.user,
  });

  factory UserResponseDTO.fromJson(dynamic json) {
    debugPrint('UserResponseDTO.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        if (json.containsKey('user') && json['user'] is Map<String, dynamic>) {
          return UserResponseDTO(
            user: User.fromJson(json['user'] as Map<String, dynamic>),
          );
        } else {
          throw FormatException(
              'Missing or invalid user field in response: $json');
        }
      } else {
        throw FormatException('Unsupported JSON format for user: $json');
      }
    } catch (e) {
      debugPrint('Error in UserResponseDTO.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
    };
  }
}

class UsersResponseDTO {
  final List<User> users;

  UsersResponseDTO({
    required this.users,
  });

  factory UsersResponseDTO.fromJson(dynamic json) {
    debugPrint('UsersResponseDTO.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        if (json.containsKey('users')) {
          var usersJson = json['users'] as List<dynamic>? ?? [];
          List<User> usersList = usersJson.map((item) {
            if (item is Map<String, dynamic>) {
              return User.fromJson(item);
            } else {
              throw FormatException('Invalid user item format: $item');
            }
          }).toList();

          return UsersResponseDTO(
            users: usersList,
          );
        } else {
          throw FormatException('Missing users field in response: $json');
        }
      } else {
        throw FormatException('Unsupported JSON format for users list: $json');
      }
    } catch (e) {
      debugPrint('Error in UsersResponseDTO.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users.map((user) => user.toJson()).toList(),
    };
  }
}
