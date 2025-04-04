import 'package:bloc/bloc.dart';
import 'package:elderwise/domain/repositories/user_repository.dart';
import 'package:elderwise/presentation/bloc/user/user_event.dart';
import 'package:elderwise/presentation/bloc/user/user_state.dart';

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
      if (response.success) {
        emit(UserSuccess(response));
      } else {
        emit(UserFailure(response.message));
      }
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }

  Future<void> _onGetUserCaregivers(
      GetUserCaregiversEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final response = await userRepository.getUserCaregivers(event.userId);
      if (response.success) {
        emit(UserSuccess(response));
      } else {
        emit(UserFailure(response.message));
      }
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }

  Future<void> _onGetUserElders(
      GetUserEldersEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final response = await userRepository.getUserElders(event.userId);
      if (response.success) {
        emit(UserSuccess(response));
      } else {
        emit(UserFailure(response.message));
      }
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }
}
