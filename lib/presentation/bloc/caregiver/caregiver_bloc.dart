import 'package:bloc/bloc.dart';
import 'package:elderwise/data/api/responses/caregiver_response.dart';
import 'package:elderwise/domain/repositories/caregiver_repository.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_event.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_state.dart';
import 'package:flutter/material.dart';

class CaregiverBloc extends Bloc<CaregiverEvent, CaregiverState> {
  final CaregiverRepository caregiverRepository;

  CaregiverBloc(this.caregiverRepository) : super(CaregiverInitial()) {
    on<GetCaregiverEvent>(_onGetCaregiver);
    on<CreateCaregiverEvent>(_onCreateCaregiver);
    on<UpdateCaregiverEvent>(_onUpdateCaregiver);
  }

  Future<void> _onGetCaregiver(
      GetCaregiverEvent event, Emitter<CaregiverState> emit) async {
    emit(CaregiverLoading());
    try {
      final response =
          await caregiverRepository.getCaregiverByID(event.caregiverId);
      debugPrint(response.data.toString());
      if (response.success) {
        emit(CaregiverSuccess(CaregiverResponseDTO.fromJson(response.data)));
      } else {
        emit(CaregiverFailure(response.message));
      }
    } catch (e) {
      emit(CaregiverFailure(e.toString()));
    }
  }

  Future<void> _onCreateCaregiver(
      CreateCaregiverEvent event, Emitter<CaregiverState> emit) async {
    emit(CaregiverLoading());
    try {
      final response =
          await caregiverRepository.createCaregiver(event.caregiver);
      debugPrint(response.data.toString());
      if (response.success) {
        emit(CaregiverSuccess(CaregiverResponseDTO.fromJson(response.data)));
      } else {
        emit(CaregiverFailure(response.message));
      }
    } catch (e) {
      emit(CaregiverFailure(e.toString()));
    }
  }

  Future<void> _onUpdateCaregiver(
      UpdateCaregiverEvent event, Emitter<CaregiverState> emit) async {
    emit(CaregiverLoading());
    try {
      final response = await caregiverRepository.updateCaregiver(
          event.caregiverId, event.caregiver);
      debugPrint(response.data.toString());
      if (response.success) {
        emit(CaregiverSuccess(CaregiverResponseDTO.fromJson(response.data)));
      } else {
        emit(CaregiverFailure(response.message));
      }
    } catch (e) {
      emit(CaregiverFailure(e.toString()));
    }
  }
}
