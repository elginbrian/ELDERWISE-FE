import 'package:bloc/bloc.dart';
import 'package:elderwise/data/api/responses/area_response.dart';
import 'package:elderwise/domain/repositories/area_repository.dart';
import 'package:elderwise/presentation/bloc/area/area_event.dart';
import 'package:elderwise/presentation/bloc/area/area_state.dart';
import 'package:flutter/material.dart';

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

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(AreaSuccess(AreaResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in area data processing: $e');
          emit(AreaFailure('Error processing area data'));
        }
      } else {
        emit(AreaFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get area exception: $e');
      emit(AreaFailure(e.toString()));
    }
  }

  Future<void> _onCreateArea(
      CreateAreaEvent event, Emitter<AreaState> emit) async {
    emit(AreaLoading());
    try {
      final response = await areaRepository.createArea(event.areaRequest);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(AreaSuccess(AreaResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in area data processing: $e');
          emit(AreaFailure('Error processing area data'));
        }
      } else {
        emit(AreaFailure(response.message));
      }
    } catch (e) {
      debugPrint('Create area exception: $e');
      emit(AreaFailure(e.toString()));
    }
  }

  Future<void> _onUpdateArea(
      UpdateAreaEvent event, Emitter<AreaState> emit) async {
    emit(AreaLoading());
    try {
      final response =
          await areaRepository.updateArea(event.areaId, event.areaRequest);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(AreaSuccess(AreaResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in area data processing: $e');
          emit(AreaFailure('Error processing area data'));
        }
      } else {
        emit(AreaFailure(response.message));
      }
    } catch (e) {
      debugPrint('Update area exception: $e');
      emit(AreaFailure(e.toString()));
    }
  }

  Future<void> _onDeleteArea(
      DeleteAreaEvent event, Emitter<AreaState> emit) async {
    emit(AreaLoading());
    try {
      final response = await areaRepository.deleteArea(event.areaId);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(AreaSuccess(AreaResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in area data processing: $e');
          emit(AreaFailure('Error processing area data'));
        }
      } else {
        emit(AreaFailure(response.message));
      }
    } catch (e) {
      debugPrint('Delete area exception: $e');
      emit(AreaFailure(e.toString()));
    }
  }

  Future<void> _onGetAreasByCaregiver(
      GetAreasByCaregiverEvent event, Emitter<AreaState> emit) async {
    emit(AreaLoading());
    try {
      final response =
          await areaRepository.getAreasByCaregiver(event.caregiverId);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          final areasData = {'areas': response.data['areas']};
          emit(AreasSuccess(AreasResponseDTO.fromJson(areasData)));
        } catch (e) {
          debugPrint('Error in areas data processing: $e');
          emit(AreaFailure('Error processing areas data'));
        }
      } else {
        emit(AreaFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get areas by caregiver exception: $e');
      emit(AreaFailure(e.toString()));
    }
  }
}
