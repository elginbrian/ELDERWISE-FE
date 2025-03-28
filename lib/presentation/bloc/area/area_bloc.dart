import 'package:bloc/bloc.dart';
import 'package:elderwise/data/api/responses/area_response.dart';
import 'package:elderwise/domain/repositories/area_repository.dart';
import 'package:elderwise/presentation/bloc/area/area_event.dart';
import 'package:elderwise/presentation/bloc/area/area_state.dart';

class AreaBloc extends Bloc<AreaEvent, AreaState> {
  final AreaRepository areaRepository;

  AreaBloc(this.areaRepository) : super(AreaInitial()) {
    on<GetAreaEvent>(_onGetArea);
    on<CreateAreaEvent>(_onCreateArea);
    on<UpdateAreaEvent>(_onUpdateArea);
    on<DeleteAreaEvent>(_onDeleteArea);
    on<GetAreasByCaregiverEvent>(_onGetAreasByCaregiver);
  }

  Future<void> _onGetArea(GetAreaEvent event, Emitter<AreaState> emit) async {
    emit(AreaLoading());
    try {
      final response = await areaRepository.getAreaByID(event.areaId);
      if (response.success) {
        emit(AreaSuccess(AreaResponseDTO.fromJson(response.data)));
      } else {
        emit(AreaFailure(response.message));
      }
    } catch (e) {
      emit(AreaFailure(e.toString()));
    }
  }

  Future<void> _onCreateArea(
      CreateAreaEvent event, Emitter<AreaState> emit) async {
    emit(AreaLoading());
    try {
      final response = await areaRepository.createArea(event.areaRequest);
      if (response.success) {
        emit(AreaSuccess(AreaResponseDTO.fromJson(response.data)));
      } else {
        emit(AreaFailure(response.message));
      }
    } catch (e) {
      emit(AreaFailure(e.toString()));
    }
  }

  Future<void> _onUpdateArea(
      UpdateAreaEvent event, Emitter<AreaState> emit) async {
    emit(AreaLoading());
    try {
      final response =
          await areaRepository.updateArea(event.areaId, event.areaRequest);
      if (response.success) {
        emit(AreaSuccess(AreaResponseDTO.fromJson(response.data)));
      } else {
        emit(AreaFailure(response.message));
      }
    } catch (e) {
      emit(AreaFailure(e.toString()));
    }
  }

  Future<void> _onDeleteArea(
      DeleteAreaEvent event, Emitter<AreaState> emit) async {
    emit(AreaLoading());
    try {
      final response = await areaRepository.deleteArea(event.areaId);
      if (response.success) {
        emit(AreaSuccess(AreaResponseDTO.fromJson(response.data)));
      } else {
        emit(AreaFailure(response.message));
      }
    } catch (e) {
      emit(AreaFailure(e.toString()));
    }
  }

  Future<void> _onGetAreasByCaregiver(
      GetAreasByCaregiverEvent event, Emitter<AreaState> emit) async {
    emit(AreaLoading());
    try {
      final response =
          await areaRepository.getAreasByCaregiver(event.caregiverId);
      if (response.success) {
        emit(AreasSuccess(AreasResponseDTO.fromJson(response.data)));
      } else {
        emit(AreaFailure(response.message));
      }
    } catch (e) {
      emit(AreaFailure(e.toString()));
    }
  }
}
