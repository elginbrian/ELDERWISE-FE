import 'package:dio/dio.dart';
import 'package:elderwise/data/api/api_config.dart';
import 'package:elderwise/data/api/requests/location_history_request.dart';
import 'package:elderwise/data/api/responses/response_wrapper.dart';
import 'package:elderwise/domain/repositories/location_history_repository.dart';
import 'package:flutter/material.dart';

class LocationHistoryRepositoryImpl implements LocationHistoryRepository {
  final Dio dio;

  LocationHistoryRepositoryImpl({Dio? dio}) : dio = dio ?? ApiConfig.dio;

  @override
  Future<ResponseWrapper> getLocationHistoryByID(
      String locationHistoryId) async {
    final response =
        await dio.get(ApiConfig.getLocationHistory(locationHistoryId));
    debugPrint("Repository: ${response.data}");
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> getLocationHistoryPoints(
      String locationHistoryId) async {
    final response =
        await dio.get(ApiConfig.getLocationHistoryPoints(locationHistoryId));
    debugPrint("Repository: ${response.data}");
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> addLocationPoint(String locationHistoryId,
      LocationHistoryPointRequestDTO requestDTO) async {
    final response = await dio.post(
      ApiConfig.addLocationHistoryPoint(locationHistoryId),
      data: requestDTO.toJson(),
    );
    debugPrint("Repository: ${response.data}");
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> createLocationHistory(
      LocationHistoryRequestDTO requestDTO) async {
    final response = await dio.post(
      ApiConfig.createLocationHistory,
      data: requestDTO.toJson(),
    );
    debugPrint("Repository: ${response.data}");
    return ResponseWrapper.fromJson(response.data);
  }
}
