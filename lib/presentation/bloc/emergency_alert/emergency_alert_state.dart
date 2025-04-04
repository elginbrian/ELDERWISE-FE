import 'package:elderwise/data/api/responses/emergency_alert_response.dart';

abstract class EmergencyAlertState {}

class EmergencyAlertInitial extends EmergencyAlertState {}

class EmergencyAlertLoading extends EmergencyAlertState {}

class EmergencyAlertSuccess extends EmergencyAlertState {
  final EmergencyAlertResponseDTO response;
  EmergencyAlertSuccess(this.response);
}

class EmergencyAlertFailure extends EmergencyAlertState {
  final String error;
  EmergencyAlertFailure(this.error);
}
