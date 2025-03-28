import 'package:dio/dio.dart';
import 'package:elderwise/data/api/api_config.dart';
import 'package:elderwise/data/api/requests/emergency_alert_request.dart';
import 'package:elderwise/data/api/responses/response_wrapper.dart';
import 'package:elderwise/domain/repositories/emergency_alert_repository.dart';

class EmergencyAlertRepositoryImpl implements EmergencyAlertRepository {
  final Dio dio;

  EmergencyAlertRepositoryImpl({Dio? dio}) : dio = dio ?? ApiConfig.dio;

  @override
  Future<ResponseWrapper> getEmergencyAlertByID(String alertId) async {
    final response = await dio.get(ApiConfig.getEmergencyAlert(alertId));
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> createEmergencyAlert(
      EmergencyAlertRequestDTO alertRequest) async {
    final response = await dio.post(ApiConfig.createEmergencyAlert,
        data: alertRequest.toJson());
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> updateEmergencyAlert(
      String alertId, EmergencyAlertRequestDTO alertRequest) async {
    final response = await dio.put(ApiConfig.updateEmergencyAlert(alertId),
        data: alertRequest.toJson());
    return ResponseWrapper.fromJson(response.data);
  }
}
