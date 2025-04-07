import 'package:dio/dio.dart';
import 'package:elderwise/data/api/api_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;

  final List<String> _publicEndpoints = [
    ApiConfig.login,
    ApiConfig.register,
  ];

  TokenInterceptor({required this.dio});

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<String?> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentToken = prefs.getString('auth_token');
      if (currentToken == null) return null;

      return currentToken;
    } catch (e) {
      debugPrint('Error refreshing token: $e');
      return null;
    }
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (_publicEndpoints.contains(options.path)) {
      return handler.next(options);
    }

    final token = await _getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final options = err.requestOptions;

      if (_publicEndpoints.contains(options.path)) {
        return handler.next(err);
      }

      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          options.headers['Authorization'] = 'Bearer $newToken';
          final response = await dio.fetch(options);
          handler.resolve(response);
          return;
        }
      } catch (e) {
        debugPrint('Error during token refresh: $e');
      }
    }
    handler.next(err);
  }
}
