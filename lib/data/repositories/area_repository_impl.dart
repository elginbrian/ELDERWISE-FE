import 'package:dio/dio.dart';
import 'package:elderwise/data/api/api_config.dart';
import 'package:elderwise/data/api/requests/area_request.dart';
import 'package:elderwise/data/api/responses/response_wrapper.dart';
import 'package:elderwise/domain/repositories/area_repository.dart';
import 'package:flutter/foundation.dart';

class AreaRepositoryImpl implements AreaRepository {
  final Dio dio;

  AreaRepositoryImpl({Dio? dio}) : dio = dio ?? ApiConfig.dio;

  @override
  Future<ResponseWrapper> getAreaByID(String areaId) async {
    final response = await dio.get(ApiConfig.getArea(areaId));
    debugPrint("Repository: ${response.data}");
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> createArea(AreaRequestDTO areaRequest) async {
    final response =
        await dio.post(ApiConfig.createArea, data: areaRequest.toJson());
    debugPrint("Repository: ${response.data}");
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> updateArea(
      String areaId, AreaRequestDTO areaRequest) async {
    final response =
        await dio.put(ApiConfig.updateArea(areaId), data: areaRequest.toJson());
    debugPrint("Repository: ${response.data}");
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> deleteArea(String areaId) async {
    final response = await dio.delete(ApiConfig.deleteArea(areaId));
    debugPrint("Repository: ${response.data}");
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> getAreasByCaregiver(String caregiverId) async {
    final response = await dio.get(ApiConfig.getCaregiverAreas(caregiverId));
    debugPrint("Repository: ${response.data}");
    return ResponseWrapper.fromJson(response.data);
  }
}
