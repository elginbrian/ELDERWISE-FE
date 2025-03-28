import 'package:dio/dio.dart';
import 'package:elderwise/data/api/api_config.dart';
import 'package:elderwise/data/api/responses/response_wrapper.dart';
import 'package:elderwise/domain/entities/caregiver.dart';
import 'package:elderwise/domain/repositories/caregiver_repository.dart';

class CaregiverRepositoryImpl implements CaregiverRepository {
  final Dio dio;

  CaregiverRepositoryImpl({Dio? dio}) : dio = dio ?? ApiConfig.dio;

  @override
  Future<ResponseWrapper> getCaregiverByID(String caregiverId) async {
    final response = await dio.get(ApiConfig.getCaregiver(caregiverId));
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> createCaregiver(Caregiver caregiverRequest) async {
    final response = await dio.post(
      ApiConfig.createCaregiver,
      data: caregiverRequest.toJson(),
    );
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> updateCaregiver(
      String caregiverId, Caregiver caregiverRequest) async {
    final response = await dio.put(
      ApiConfig.updateCaregiver(caregiverId),
      data: caregiverRequest.toJson(),
    );
    return ResponseWrapper.fromJson(response.data);
  }
}
