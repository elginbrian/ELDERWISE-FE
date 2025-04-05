import 'package:bloc/bloc.dart';
import 'package:elderwise/data/api/responses/agenda_response.dart';
import 'package:elderwise/data/api/responses/area_response.dart';
import 'package:elderwise/data/api/responses/elder_response.dart';
import 'package:elderwise/data/api/responses/emergency_alert_response.dart';
import 'package:elderwise/data/api/responses/location_history_response.dart';
import 'package:elderwise/domain/repositories/elder_repository.dart';
import 'package:elderwise/presentation/bloc/elder/elder_event.dart';
import 'package:elderwise/presentation/bloc/elder/elder_state.dart';
import 'package:flutter/material.dart';

class ElderBloc extends Bloc<ElderEvent, ElderState> {
  final ElderRepository elderRepository;

  ElderBloc(this.elderRepository) : super(ElderInitial()) {
    on<GetElderEvent>(_onGetElder);
    on<CreateElderEvent>(_onCreateElder);
    on<UpdateElderEvent>(_onUpdateElder);
    on<GetElderAreasEvent>(_onGetElderAreas);
    on<GetElderLocationHistoryEvent>(_onGetElderLocationHistory);
    on<GetElderAgendasEvent>(_onGetElderAgendas);
    on<GetElderEmergencyAlertsEvent>(_onGetElderEmergencyAlerts);
  }

  Future<void> _onGetElder(
      GetElderEvent event, Emitter<ElderState> emit) async {
    emit(ElderLoading());
    try {
      final response = await elderRepository.getElderByID(event.elderId);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(ElderSuccess(ElderResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in elder data processing: $e');
          emit(ElderFailure('Error processing elder data'));
        }
      } else {
        emit(ElderFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get elder exception: $e');
      emit(ElderFailure(e.toString()));
    }
  }

  Future<void> _onCreateElder(
      CreateElderEvent event, Emitter<ElderState> emit) async {
    emit(ElderLoading());
    try {
      final response = await elderRepository.createElder(event.elder);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(ElderSuccess(ElderResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in elder data processing: $e');
          emit(ElderFailure('Error processing elder data'));
        }
      } else {
        emit(ElderFailure(response.message));
      }
    } catch (e) {
      debugPrint('Create elder exception: $e');
      emit(ElderFailure(e.toString()));
    }
  }

  Future<void> _onUpdateElder(
      UpdateElderEvent event, Emitter<ElderState> emit) async {
    emit(ElderLoading());
    try {
      final response =
          await elderRepository.updateElder(event.elderId, event.elder);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(ElderSuccess(ElderResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in elder data processing: $e');
          emit(ElderFailure('Error processing elder data'));
        }
      } else {
        emit(ElderFailure(response.message));
      }
    } catch (e) {
      debugPrint('Update elder exception: $e');
      emit(ElderFailure(e.toString()));
    }
  }

  Future<void> _onGetElderAreas(
      GetElderAreasEvent event, Emitter<ElderState> emit) async {
    emit(ElderLoading());
    try {
      final response = await elderRepository.getElderAreas(event.elderId);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(AreasSuccess(AreasResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in areas data processing: $e');
          emit(ElderFailure('Error processing areas data'));
        }
      } else {
        emit(ElderFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get elder areas exception: $e');
      emit(ElderFailure(e.toString()));
    }
  }

  Future<void> _onGetElderLocationHistory(
      GetElderLocationHistoryEvent event, Emitter<ElderState> emit) async {
    emit(ElderLoading());
    try {
      final response =
          await elderRepository.getElderLocationHistory(event.elderId);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(LocationHistorySuccess(
              LocationHistoryResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in location history data processing: $e');
          emit(ElderFailure('Error processing location history data'));
        }
      } else {
        emit(ElderFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get elder location history exception: $e');
      emit(ElderFailure(e.toString()));
    }
  }

  Future<void> _onGetElderAgendas(
      GetElderAgendasEvent event, Emitter<ElderState> emit) async {
    emit(ElderLoading());
    try {
      final response = await elderRepository.getElderAgendas(event.elderId);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(AgendasSuccess(AgendasResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in agendas data processing: $e');
          emit(ElderFailure('Error processing agendas data'));
        }
      } else {
        emit(ElderFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get elder agendas exception: $e');
      emit(ElderFailure(e.toString()));
    }
  }

  Future<void> _onGetElderEmergencyAlerts(
      GetElderEmergencyAlertsEvent event, Emitter<ElderState> emit) async {
    emit(ElderLoading());
    try {
      final response =
          await elderRepository.getElderEmergencyAlerts(event.elderId);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(EmergencyAlertSuccess(
              EmergencyAlertResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in emergency alerts data processing: $e');
          emit(ElderFailure('Error processing emergency alerts data'));
        }
      } else {
        emit(ElderFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get elder emergency alerts exception: $e');
      emit(ElderFailure(e.toString()));
    }
  }
}
