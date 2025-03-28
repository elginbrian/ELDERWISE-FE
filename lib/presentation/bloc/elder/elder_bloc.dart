import 'package:bloc/bloc.dart';
import 'package:elderwise/data/api/responses/agenda_response.dart';
import 'package:elderwise/data/api/responses/area_response.dart';
import 'package:elderwise/data/api/responses/elder_response.dart';
import 'package:elderwise/data/api/responses/emergency_alert_response.dart';
import 'package:elderwise/data/api/responses/location_history_response.dart';
import 'package:elderwise/domain/repositories/elder_repository.dart';
import 'package:elderwise/presentation/bloc/elder/elder_event.dart';
import 'package:elderwise/presentation/bloc/elder/elder_state.dart';

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
      if (response.success) {
        emit(ElderSuccess(ElderResponseDTO.fromJson(response.data)));
      } else {
        emit(ElderFailure(response.message));
      }
    } catch (e) {
      emit(ElderFailure(e.toString()));
    }
  }

  Future<void> _onCreateElder(
      CreateElderEvent event, Emitter<ElderState> emit) async {
    emit(ElderLoading());
    try {
      final response = await elderRepository.createElder(event.elder);
      if (response.success) {
        emit(ElderSuccess(ElderResponseDTO.fromJson(response.data)));
      } else {
        emit(ElderFailure(response.message));
      }
    } catch (e) {
      emit(ElderFailure(e.toString()));
    }
  }

  Future<void> _onUpdateElder(
      UpdateElderEvent event, Emitter<ElderState> emit) async {
    emit(ElderLoading());
    try {
      final response =
          await elderRepository.updateElder(event.elderId, event.elder);
      if (response.success) {
        emit(ElderSuccess(ElderResponseDTO.fromJson(response.data)));
      } else {
        emit(ElderFailure(response.message));
      }
    } catch (e) {
      emit(ElderFailure(e.toString()));
    }
  }

  Future<void> _onGetElderAreas(
      GetElderAreasEvent event, Emitter<ElderState> emit) async {
    emit(ElderLoading());
    try {
      final response = await elderRepository.getElderAreas(event.elderId);
      if (response.success) {
        emit(AreasSuccess(AreasResponseDTO.fromJson(response.data)));
      } else {
        emit(ElderFailure(response.message));
      }
    } catch (e) {
      emit(ElderFailure(e.toString()));
    }
  }

  Future<void> _onGetElderLocationHistory(
      GetElderLocationHistoryEvent event, Emitter<ElderState> emit) async {
    emit(ElderLoading());
    try {
      final response =
          await elderRepository.getElderLocationHistory(event.elderId);
      if (response.success) {
        emit(LocationHistorySuccess(
            LocationHistoryResponseDTO.fromJson(response.data)));
      } else {
        emit(ElderFailure(response.message));
      }
    } catch (e) {
      emit(ElderFailure(e.toString()));
    }
  }

  Future<void> _onGetElderAgendas(
      GetElderAgendasEvent event, Emitter<ElderState> emit) async {
    emit(ElderLoading());
    try {
      final response = await elderRepository.getElderAgendas(event.elderId);
      if (response.success) {
        emit(AgendasSuccess(AgendasResponseDTO.fromJson(response.data)));
      } else {
        emit(ElderFailure(response.message));
      }
    } catch (e) {
      emit(ElderFailure(e.toString()));
    }
  }

  Future<void> _onGetElderEmergencyAlerts(
      GetElderEmergencyAlertsEvent event, Emitter<ElderState> emit) async {
    emit(ElderLoading());
    try {
      final response =
          await elderRepository.getElderEmergencyAlerts(event.elderId);
      if (response.success) {
        emit(EmergencyAlertSuccess(
            EmergencyAlertResponseDTO.fromJson(response.data)));
      } else {
        emit(ElderFailure(response.message));
      }
    } catch (e) {
      emit(ElderFailure(e.toString()));
    }
  }
}
