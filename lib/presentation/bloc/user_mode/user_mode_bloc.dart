import 'package:elderwise/data/repositories/user_mode_repository.dart';
import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elderwise/services/fall_detection_service.dart';
import 'package:elderwise/services/location_tracking_service.dart';
import 'package:flutter/material.dart';

abstract class UserModeEvent {}

class InitializeUserModeEvent extends UserModeEvent {}

class ToggleUserModeEvent extends UserModeEvent {
  final UserMode targetMode;

  ToggleUserModeEvent(this.targetMode);
}

class ChangeUserModeEvent extends UserModeEvent {
  final UserMode userMode;

  ChangeUserModeEvent(this.userMode);
}

abstract class UserModeState {
  final UserMode userMode;
  const UserModeState(this.userMode);
}

class UserModeInitial extends UserModeState {
  const UserModeInitial() : super(UserMode.caregiver);
}

class UserModeLoaded extends UserModeState {
  const UserModeLoaded(UserMode userMode) : super(userMode);
}

class UserModeBloc extends Bloc<UserModeEvent, UserModeState> {
  final UserModeRepository _userModeRepository = UserModeRepository();
  final LocationTrackingService _locationTrackingService =
      LocationTrackingService();
  String? _elderId;

  UserModeBloc() : super(const UserModeInitial()) {
    on<InitializeUserModeEvent>(_onInitializeUserMode);
    on<ToggleUserModeEvent>(_onToggleUserMode);
    on<ChangeUserModeEvent>(_onChangeUserMode);
  }

  void setElderId(String elderId) {
    _elderId = elderId;
    if (state.userMode == UserMode.elder &&
        !_locationTrackingService.isActive) {
      _startLocationTracking();
    }
  }

  Future<void> _onInitializeUserMode(
    InitializeUserModeEvent event,
    Emitter<UserModeState> emit,
  ) async {
    final userMode = await _userModeRepository.getUserMode();
    emit(UserModeLoaded(userMode));

    FallDetectionService().updateUserMode(userMode);

    if (userMode == UserMode.elder && _elderId != null) {
      _startLocationTracking();
    } else {
      _locationTrackingService.stopTracking();
    }
  }

  Future<void> _onToggleUserMode(
    ToggleUserModeEvent event,
    Emitter<UserModeState> emit,
  ) async {
    await _userModeRepository.setUserMode(event.targetMode);
    emit(UserModeLoaded(event.targetMode));

    FallDetectionService().updateUserMode(event.targetMode);

    if (event.targetMode == UserMode.elder && _elderId != null) {
      _startLocationTracking();
    } else {
      _locationTrackingService.stopTracking();
    }
  }

  void _onChangeUserMode(
    ChangeUserModeEvent event,
    Emitter<UserModeState> emit,
  ) {
    emit(UserModeLoaded(event.userMode));

    FallDetectionService().updateUserMode(event.userMode);

    if (event.userMode == UserMode.elder && _elderId != null) {
      _startLocationTracking();
    } else {
      _locationTrackingService.stopTracking();
    }
  }

  void _startLocationTracking() {
    if (_elderId == null) {
      debugPrint('Cannot start location tracking: Elder ID is null');
      return;
    }

    _locationTrackingService.startTracking(_elderId!);
  }
}
