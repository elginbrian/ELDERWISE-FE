import 'package:dio/dio.dart';
import 'package:elderwise/data/api/api_config.dart';
import 'package:elderwise/data/api/responses/response_wrapper.dart';
import 'package:elderwise/domain/repositories/location_history_repository.dart';

class LocationHistoryRepositoryImpl implements LocationHistoryRepository {
  final Dio dio;

  LocationHistoryRepositoryImpl({Dio? dio}) : dio = dio ?? ApiConfig.dio;

  @override
  Future<ResponseWrapper> getLocationHistoryByID(
      String locationHistoryId) async {
    final response =
        await dio.get(ApiConfig.getLocationHistory(locationHistoryId));
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> getLocationHistoryPoints(
      String locationHistoryId) async {
    final response =
        await dio.get(ApiConfig.getLocationHistoryPoints(locationHistoryId));
    return ResponseWrapper.fromJson(response.data);
  }
}
