import 'package:elderwise/data/api/requests/auth_request.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final LoginRequestDTO loginRequest;
  LoginEvent(this.loginRequest);
}

class RegisterEvent extends AuthEvent {
  final RegisterRequestDTO registerRequest;
  RegisterEvent(this.registerRequest);
}

class GoogleSignInEvent extends AuthEvent {
  final GoogleAuthRequestDTO request;
  GoogleSignInEvent(this.request);
}

class GetCurrentUserEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
