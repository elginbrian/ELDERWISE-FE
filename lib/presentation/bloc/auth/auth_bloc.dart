import 'package:bloc/bloc.dart';
import 'package:elderwise/data/api/responses/auth_response.dart';
import 'package:elderwise/domain/repositories/auth_repository.dart';
import 'package:elderwise/presentation/bloc/auth/auth_event.dart';
import 'package:elderwise/presentation/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<GoogleSignInEvent>(_onGoogleSignIn);
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
      emit(LoginSuccess(result));
    } catch (e) {
      debugPrint('Google sign in exception: $e');
      emit(AuthFailure(e.toString()));
    }
  }
}
