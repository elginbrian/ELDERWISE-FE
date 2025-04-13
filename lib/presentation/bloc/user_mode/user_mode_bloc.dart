import 'package:elderwise/data/repositories/user_mode_repository.dart';
import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UserModeEvent {}

class InitializeUserModeEvent extends UserModeEvent {}

class ToggleUserModeEvent extends UserModeEvent {
  final UserMode targetMode;

  ToggleUserModeEvent(this.targetMode);
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

  UserModeBloc() : super(const UserModeInitial()) {
    on<InitializeUserModeEvent>(_onInitializeUserMode);
    on<ToggleUserModeEvent>(_onToggleUserMode);
  }

  Future<void> _onInitializeUserMode(
    InitializeUserModeEvent event,
    Emitter<UserModeState> emit,
  ) async {
    final userMode = await _userModeRepository.getUserMode();
    emit(UserModeLoaded(userMode));
  }

  Future<void> _onToggleUserMode(
    ToggleUserModeEvent event,
    Emitter<UserModeState> emit,
  ) async {
    await _userModeRepository.setUserMode(event.targetMode);
    emit(UserModeLoaded(event.targetMode));
  }
}
