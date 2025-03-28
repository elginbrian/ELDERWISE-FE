import 'package:elderwise/data/api/requests/emergency_alert_request.dart';

abstract class EmergencyAlertEvent {}

class GetEmergencyAlertEvent extends EmergencyAlertEvent {
  final String alertId;
  GetEmergencyAlertEvent(this.alertId);
}

class CreateEmergencyAlertEvent extends EmergencyAlertEvent {
  final EmergencyAlertRequestDTO alertRequest;
  CreateEmergencyAlertEvent(this.alertRequest);
}

class UpdateEmergencyAlertEvent extends EmergencyAlertEvent {
  final String alertId;
  final EmergencyAlertRequestDTO alertRequest;
  UpdateEmergencyAlertEvent(this.alertId, this.alertRequest);
}
