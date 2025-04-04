import 'package:dio/dio.dart';
import 'package:elderwise/data/api/api_config.dart';
import 'package:elderwise/data/api/requests/auth_request.dart';
import 'package:elderwise/data/api/responses/response_wrapper.dart';
import 'package:elderwise/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;

  AuthRepositoryImpl({Dio? dio}) : dio = dio ?? ApiConfig.dio;

  @override
  Future<ResponseWrapper> register(RegisterRequestDTO request) async {
    final response = await dio.post(ApiConfig.register, data: request.toJson());
    debugPrint("Repository: ${response.data}");
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> login(LoginRequestDTO request) async {
    final response = await dio.post(ApiConfig.login, data: request.toJson());
    debugPrint("Repository: ${response.data}");
    final responseWrapper = ResponseWrapper.fromJson(response.data);
    if (responseWrapper.success) {
      final token = responseWrapper.data['token'] as String?;
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
      }
    }
    return responseWrapper;
  }
}
