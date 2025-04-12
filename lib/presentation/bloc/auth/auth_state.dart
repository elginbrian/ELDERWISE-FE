import 'package:elderwise/data/api/responses/auth_response.dart';
import 'package:elderwise/data/api/responses/user_response.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final LoginResponseDTO response;
  LoginSuccess(this.response);
}

class RegisterSuccess extends AuthState {
  final RegisterResponseDTO response;
  RegisterSuccess(this.response);
}

class CurrentUserSuccess extends AuthState {
  final UserResponseDTO user;
  CurrentUserSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}
