import 'package:dio/dio.dart';
import 'package:elderwise/data/api/api_config.dart';
import 'package:elderwise/data/api/responses/response_wrapper.dart';
import 'package:elderwise/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final Dio dio;

  UserRepositoryImpl({Dio? dio}) : dio = dio ?? ApiConfig.dio;

  @override
  Future<ResponseWrapper> getUserByID(String userId) async {
    final response = await dio.get(ApiConfig.getUser(userId));
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> getUserCaregivers(String userId) async {
    final response = await dio.get(ApiConfig.getUserCaregivers(userId));
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> getUserElders(String userId) async {
    final response = await dio.get(ApiConfig.getUserElders(userId));
    return ResponseWrapper.fromJson(response.data);
  }
}
