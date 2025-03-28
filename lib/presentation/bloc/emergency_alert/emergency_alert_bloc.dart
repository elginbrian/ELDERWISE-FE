import 'package:bloc/bloc.dart';
import 'package:elderwise/data/api/responses/emergency_alert_response.dart';
import 'package:elderwise/domain/repositories/emergency_alert_repository.dart';
import 'package:elderwise/presentation/bloc/emergency_alert/emergency_alert_event.dart';
import 'package:elderwise/presentation/bloc/emergency_alert/emergency_alert_state.dart';

class EmergencyAlertBloc
    extends Bloc<EmergencyAlertEvent, EmergencyAlertState> {
  final EmergencyAlertRepository repository;

  EmergencyAlertBloc(this.repository) : super(EmergencyAlertInitial()) {
    on<GetEmergencyAlertEvent>(_onGetEmergencyAlert);
    on<CreateEmergencyAlertEvent>(_onCreateEmergencyAlert);
    on<UpdateEmergencyAlertEvent>(_onUpdateEmergencyAlert);
  }

  Future<void> _onGetEmergencyAlert(
      GetEmergencyAlertEvent event, Emitter<EmergencyAlertState> emit) async {
    emit(EmergencyAlertLoading());
    try {
      final response = await repository.getEmergencyAlertByID(event.alertId);
      if (response.success) {
        emit(EmergencyAlertSuccess(
            EmergencyAlertResponseDTO.fromJson(response.data)));
      } else {
        emit(EmergencyAlertFailure(response.message));
      }
    } catch (e) {
      emit(EmergencyAlertFailure(e.toString()));
    }
  }

  Future<void> _onCreateEmergencyAlert(CreateEmergencyAlertEvent event,
      Emitter<EmergencyAlertState> emit) async {
    emit(EmergencyAlertLoading());
    try {
      final response =
          await repository.createEmergencyAlert(event.alertRequest);
      if (response.success) {
        emit(EmergencyAlertSuccess(
            EmergencyAlertResponseDTO.fromJson(response.data)));
      } else {
        emit(EmergencyAlertFailure(response.message));
      }
    } catch (e) {
      emit(EmergencyAlertFailure(e.toString()));
    }
  }

  Future<void> _onUpdateEmergencyAlert(UpdateEmergencyAlertEvent event,
      Emitter<EmergencyAlertState> emit) async {
    emit(EmergencyAlertLoading());
    try {
      final response = await repository.updateEmergencyAlert(
          event.alertId, event.alertRequest);
      if (response.success) {
        emit(EmergencyAlertSuccess(
            EmergencyAlertResponseDTO.fromJson(response.data)));
      } else {
        emit(EmergencyAlertFailure(response.message));
      }
    } catch (e) {
      emit(EmergencyAlertFailure(e.toString()));
    }
  }
}
