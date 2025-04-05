import 'package:bloc/bloc.dart';
import 'package:elderwise/data/api/responses/emergency_alert_response.dart';
import 'package:elderwise/domain/repositories/emergency_alert_repository.dart';
import 'package:elderwise/presentation/bloc/emergency_alert/emergency_alert_event.dart';
import 'package:elderwise/presentation/bloc/emergency_alert/emergency_alert_state.dart';
import 'package:flutter/material.dart';

class EmergencyAlertBloc
    extends Bloc<EmergencyAlertEvent, EmergencyAlertState> {
  final EmergencyAlertRepository emergencyAlertRepository;

  EmergencyAlertBloc(this.emergencyAlertRepository)
      : super(EmergencyAlertInitial()) {
    on<GetEmergencyAlertEvent>(_onGetEmergencyAlert);
    on<CreateEmergencyAlertEvent>(_onCreateEmergencyAlert);
    on<UpdateEmergencyAlertEvent>(_onUpdateEmergencyAlert);
  }

  Future<void> _onGetEmergencyAlert(
      GetEmergencyAlertEvent event, Emitter<EmergencyAlertState> emit) async {
    emit(EmergencyAlertLoading());
    try {
      final response =
          await emergencyAlertRepository.getEmergencyAlertByID(event.alertId);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(EmergencyAlertSuccess(
              EmergencyAlertResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in emergency alert data processing: $e');
          emit(EmergencyAlertFailure('Error processing emergency alert data'));
        }
      } else {
        emit(EmergencyAlertFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get emergency alert exception: $e');
      emit(EmergencyAlertFailure(e.toString()));
    }
  }

  Future<void> _onCreateEmergencyAlert(CreateEmergencyAlertEvent event,
      Emitter<EmergencyAlertState> emit) async {
    emit(EmergencyAlertLoading());
    try {
      final response = await emergencyAlertRepository
          .createEmergencyAlert(event.alertRequest);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(EmergencyAlertSuccess(
              EmergencyAlertResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in emergency alert data processing: $e');
          emit(EmergencyAlertFailure('Error processing emergency alert data'));
        }
      } else {
        emit(EmergencyAlertFailure(response.message));
      }
    } catch (e) {
      debugPrint('Create emergency alert exception: $e');
      emit(EmergencyAlertFailure(e.toString()));
    }
  }

  Future<void> _onUpdateEmergencyAlert(UpdateEmergencyAlertEvent event,
      Emitter<EmergencyAlertState> emit) async {
    emit(EmergencyAlertLoading());
    try {
      final response = await emergencyAlertRepository.updateEmergencyAlert(
          event.alertId, event.alertRequest);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(EmergencyAlertSuccess(
              EmergencyAlertResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in emergency alert data processing: $e');
          emit(EmergencyAlertFailure('Error processing emergency alert data'));
        }
      } else {
        emit(EmergencyAlertFailure(response.message));
      }
    } catch (e) {
      debugPrint('Update emergency alert exception: $e');
      emit(EmergencyAlertFailure(e.toString()));
    }
  }
}
