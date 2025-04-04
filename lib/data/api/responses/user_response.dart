import 'package:elderwise/domain/entities/user.dart';

class UserResponseDTO {
  final User user;

  UserResponseDTO({
    required this.user,
  });

  factory UserResponseDTO.fromJson(Map<String, dynamic> json) {
    return UserResponseDTO(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
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

  factory UsersResponseDTO.fromJson(Map<String, dynamic> json) {
    var usersJson = json['users'] as List<dynamic>? ?? [];
    List<User> usersList = usersJson
        .map((item) => User.fromJson(item as Map<String, dynamic>))
        .toList();

    return UsersResponseDTO(
      users: usersList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users.map((user) => user.toJson()).toList(),
    };
  }
}
