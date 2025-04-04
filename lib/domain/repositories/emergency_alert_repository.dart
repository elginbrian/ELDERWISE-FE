import 'package:elderwise/data/api/requests/emergency_alert_request.dart';
import 'package:elderwise/data/api/responses/response_wrapper.dart';

abstract class EmergencyAlertRepository {
  Future<ResponseWrapper> getEmergencyAlertByID(String alertId);
  Future<ResponseWrapper> createEmergencyAlert(
      EmergencyAlertRequestDTO alertRequest);
  Future<ResponseWrapper> updateEmergencyAlert(
      String alertId, EmergencyAlertRequestDTO alertRequest);
}
