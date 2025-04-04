import 'package:dio/dio.dart';
import 'package:elderwise/data/api/api_config.dart';
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
    debugPrint(response.data);
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> getLocationHistoryPoints(
      String locationHistoryId) async {
    final response =
        await dio.get(ApiConfig.getLocationHistoryPoints(locationHistoryId));
    debugPrint(response.data);
    return ResponseWrapper.fromJson(response.data);
  }
}
