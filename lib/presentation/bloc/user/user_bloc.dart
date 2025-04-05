import 'package:bloc/bloc.dart';
import 'package:elderwise/domain/repositories/user_repository.dart';
import 'package:elderwise/presentation/bloc/user/user_event.dart';
import 'package:elderwise/presentation/bloc/user/user_state.dart';
import 'package:flutter/material.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<GetUserEvent>(_onGetUser);
    on<GetUserCaregiversEvent>(_onGetUserCaregivers);
    on<GetUserEldersEvent>(_onGetUserElders);
  }

  Future<void> _onGetUser(GetUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final response = await userRepository.getUserByID(event.userId);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(UserSuccess(response));
        } catch (e) {
          debugPrint('Error in user data processing: $e');
          emit(UserFailure('Error processing user data'));
        }
      } else {
        emit(UserFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get user exception: $e');
      emit(UserFailure(e.toString()));
    }
  }

  Future<void> _onGetUserCaregivers(
      GetUserCaregiversEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final response = await userRepository.getUserCaregivers(event.userId);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(UserSuccess(response));
        } catch (e) {
          debugPrint('Error in user caregivers data processing: $e');
          emit(UserFailure('Error processing user caregivers data'));
        }
      } else {
        emit(UserFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get user caregivers exception: $e');
      emit(UserFailure(e.toString()));
    }
  }

  Future<void> _onGetUserElders(
      GetUserEldersEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final response = await userRepository.getUserElders(event.userId);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(UserSuccess(response));
        } catch (e) {
          debugPrint('Error in user elders data processing: $e');
          emit(UserFailure('Error processing user elders data'));
        }
      } else {
        emit(UserFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get user elders exception: $e');
      emit(UserFailure(e.toString()));
    }
  }
}
