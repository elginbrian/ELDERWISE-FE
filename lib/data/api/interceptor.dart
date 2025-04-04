import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;

  TokenInterceptor({required this.dio});

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<String?> _refreshToken() async {
    final newToken = "new_dummy_token";
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', newToken);
    return newToken;
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
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
      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          options.headers['Authorization'] = 'Bearer $newToken';
          final response = await dio.fetch(options);
          handler.resolve(response);
          return;
        }
      } catch (e) {}
    }
    handler.next(err);
  }
}
