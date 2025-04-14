import 'package:dio/dio.dart';
import 'package:elderwise/data/api/api_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;

  final List<String> _publicEndpoints = [
    ApiConfig.login,
    ApiConfig.register,
  ];

  TokenInterceptor({required this.dio});

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentToken =
          prefs.getString('token');
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
      final prefs = await SharedPreferences.getInstance();

      final refreshToken = prefs.getString('refresh_token');
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
        } catch (e) {
          await _clearTokensAndRedirect();
        }
      } else {
        await _clearTokensAndRedirect();
      }
    }

    handler.next(err);
  }

  Future<void> _clearTokensAndRedirect() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refresh_token');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentContext?.go('/login');
    });
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
