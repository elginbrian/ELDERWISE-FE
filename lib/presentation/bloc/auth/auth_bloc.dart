import 'package:bloc/bloc.dart';
import 'package:elderwise/data/api/responses/auth_response.dart';
import 'package:elderwise/data/api/responses/user_response.dart';
import 'package:elderwise/domain/entities/user.dart';
import 'package:elderwise/domain/repositories/auth_repository.dart';
import 'package:elderwise/presentation/bloc/auth/auth_event.dart';
import 'package:elderwise/presentation/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<GoogleSignInEvent>(_onGoogleSignIn);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.login(event.loginRequest);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          String token;

          if (response.data is Map) {
            Map dataMap = response.data as Map;
            if (dataMap.containsKey('token') && dataMap['token'] is String) {
              token = dataMap['token'] as String;

              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('token', token);
              debugPrint(
                  'Token saved to SharedPreferences: ${token.substring(0, 10)}...');

              emit(LoginSuccess(LoginResponseDTO(token: token)));
              return;
            }
          }

          debugPrint(
              'Could not extract token in the expected way. Data: ${response.data}');
          emit(AuthFailure('Unable to process login response'));
        } catch (e) {
          debugPrint('Error in token extraction: $e');
          emit(AuthFailure('Error processing login data'));
        }
      } else {
        emit(AuthFailure(response.message));
      }
    } catch (e) {
      debugPrint('Login exception: $e');
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.register(event.registerRequest);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          if (response.data is Map<String, dynamic>) {
            final registerResponse = RegisterResponseDTO.fromJson(
                response.data as Map<String, dynamic>);
            emit(RegisterSuccess(registerResponse));
            return;
          }

          debugPrint('Could not process response data. Data: ${response.data}');
          emit(AuthFailure('Unable to process registration response'));
        } catch (e) {
          debugPrint('Error in registration data processing: $e');
          emit(AuthFailure('Error processing registration data'));
        }
      } else {
        emit(AuthFailure(response.message));
      }
    } catch (e) {
      debugPrint('Register exception: $e');
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onGoogleSignIn(
    GoogleSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.googleSignIn(event.request);

      if (result.token.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', result.token);
        debugPrint(
            'Google Auth token saved to SharedPreferences: ${result.token.substring(0, 10)}...');
      }

      emit(LoginSuccess(result));
    } catch (e) {
      debugPrint('Google sign in exception: $e');
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onGetCurrentUser(
    GetCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.getCurrentUser();

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          if (response.data is Map<String, dynamic>) {
            if (response.data.containsKey('user')) {
              final userResponseDTO = UserResponseDTO.fromJson(response.data);
              emit(CurrentUserSuccess(userResponseDTO));
              return;
            }

            final userResponseDTO = UserResponseDTO(
                user: User.fromJson(response.data as Map<String, dynamic>));
            emit(CurrentUserSuccess(userResponseDTO));
          } else {
            debugPrint('Could not process user data. Data: ${response.data}');
            emit(AuthFailure('Unable to process user data'));
          }
        } catch (e) {
          debugPrint('Error in user data processing: $e');
          emit(AuthFailure('Error processing user data'));
        }
      } else {
        emit(AuthFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get current user exception: $e');
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('refresh_token');
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
