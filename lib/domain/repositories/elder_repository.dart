import 'package:elderwise/data/api/responses/response_wrapper.dart';
import 'package:elderwise/domain/entities/elder.dart';

abstract class ElderRepository {
  Future<ResponseWrapper> getElderByID(String elderId);
  Future<ResponseWrapper> createElder(Elder elderRequest);
  Future<ResponseWrapper> updateElder(String elderId, Elder elderRequest);
  Future<ResponseWrapper> getElderAreas(String elderId);
  Future<ResponseWrapper> getElderLocationHistory(String elderId);
  Future<ResponseWrapper> getElderAgendas(String elderId);
  Future<ResponseWrapper> getElderEmergencyAlerts(String elderId);
}
