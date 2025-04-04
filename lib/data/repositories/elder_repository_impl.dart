import 'package:dio/dio.dart';
import 'package:elderwise/data/api/api_config.dart';
import 'package:elderwise/data/api/responses/response_wrapper.dart';
import 'package:elderwise/domain/entities/elder.dart';
import 'package:elderwise/domain/repositories/elder_repository.dart';

class ElderRepositoryImpl implements ElderRepository {
  final Dio dio;

  ElderRepositoryImpl({Dio? dio}) : dio = dio ?? ApiConfig.dio;

  @override
  Future<ResponseWrapper> getElderByID(String elderId) async {
    final response = await dio.get(ApiConfig.getElder(elderId));
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> createElder(Elder elderRequest) async {
    final response =
        await dio.post(ApiConfig.createElder, data: elderRequest.toJson());
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> updateElder(
      String elderId, Elder elderRequest) async {
    final response = await dio.put(ApiConfig.updateElder(elderId),
        data: elderRequest.toJson());
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> getElderAreas(String elderId) async {
    final response = await dio.get(ApiConfig.getElderAreas(elderId));
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> getElderLocationHistory(String elderId) async {
    final response = await dio.get(ApiConfig.getElderLocationHistory(elderId));
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> getElderAgendas(String elderId) async {
    final response = await dio.get(ApiConfig.getElderAgendas(elderId));
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> getElderEmergencyAlerts(String elderId) async {
    final response = await dio.get(ApiConfig.getElderEmergencyAlerts(elderId));
    return ResponseWrapper.fromJson(response.data);
  }
}
