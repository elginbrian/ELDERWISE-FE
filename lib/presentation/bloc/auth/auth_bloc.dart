import 'package:bloc/bloc.dart';
import 'package:elderwise/data/api/responses/auth_response.dart';
import 'package:elderwise/domain/repositories/auth_repository.dart';
import 'package:elderwise/presentation/bloc/auth/auth_event.dart';
import 'package:elderwise/presentation/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.login(event.loginRequest);
      debugPrint(response.data.toString());
      if (response.success) {
        emit(LoginSuccess(LoginResponseDTO.fromJson(response.data)));
      } else {
        emit(AuthFailure(response.message));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.register(event.registerRequest);
      debugPrint(response.data.toString());
      if (response.success) {
        emit(RegisterSuccess(RegisterResponseDTO.fromJson(response.data)));
      } else {
        emit(AuthFailure(response.message));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
