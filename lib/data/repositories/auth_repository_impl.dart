import 'package:dio/dio.dart';
import 'package:elderwise/data/api/api_config.dart';
import 'package:elderwise/data/api/requests/auth_request.dart';
import 'package:elderwise/data/api/responses/auth_response.dart';
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

  @override
  Future<LoginResponseDTO> googleSignIn(GoogleAuthRequestDTO request) async {
    try {
      try {
        final loginResponse = await dio.post(
          ApiConfig.login,
          data:
              LoginRequestDTO(email: request.email, password: request.googleId)
                  .toJson(),
        );
        debugPrint("Google Auth - Login attempt: ${loginResponse.data}");

        final loginWrapper = ResponseWrapper.fromJson(loginResponse.data);

        if (loginWrapper.success) {
          final token = loginWrapper.data['token'] as String?;
          if (token != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', token);
            return LoginResponseDTO(token: token);
          }
        }

        debugPrint("Google Auth - Login failed, trying registration");
      } catch (e) {
        debugPrint("Google Auth - Login error: $e");
      }

      final registerResponse = await dio.post(
        ApiConfig.register,
        data:
            RegisterRequestDTO(email: request.email, password: request.googleId)
                .toJson(),
      );
      debugPrint("Google Auth - Register response: ${registerResponse.data}");

      final registerWrapper = ResponseWrapper.fromJson(registerResponse.data);

      if (registerWrapper.success) {
        final loginAfterRegisterResponse = await dio.post(
          ApiConfig.login,
          data: {'email': request.email, 'google_id': request.googleId},
        );

        final loginAfterRegisterWrapper =
            ResponseWrapper.fromJson(loginAfterRegisterResponse.data);

        if (loginAfterRegisterWrapper.success) {
          final token = loginAfterRegisterWrapper.data['token'] as String?;
          if (token != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', token);
            return LoginResponseDTO(token: token);
          }
        }
      }

      throw Exception(registerWrapper.message);
    } catch (e) {
      debugPrint("Google SignIn error: $e");
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  @override
  Future<ResponseWrapper> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await dio.get(
      ApiConfig.getCurrentUser,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    debugPrint("Repository - Current User: ${response.data}");
    return ResponseWrapper.fromJson(response.data);
  }
}
