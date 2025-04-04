import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  bool _isInitialized = false;
  final Map<String, String> _fallbackValues = {
    'APP_ENV': 'development',
    'DEV_API_URL': 'https://elderwise-dev.elginbrian.com/api/v1',
    'PROD_API_URL': 'https://elderwise-dev.elginbrian.com/api/v1',
    'LOCAL_PORT': '3000',
  };

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await dotenv.load(fileName: ".env");
      debugPrint("Environment variables loaded successfully from .env file");
    } catch (e) {
      debugPrint("Error loading .env file: $e");
      debugPrint("Using fallback configuration values");
    }

    _isInitialized = true;
  }

  String get(String key, {String? defaultValue}) {
    if (!_isInitialized) {
      debugPrint("Warning: AppConfig accessed before initialization");
    }

    if (dotenv.isInitialized && dotenv.env.containsKey(key)) {
      return dotenv.env[key]!;
    }

    if (_fallbackValues.containsKey(key)) {
      return _fallbackValues[key]!;
    }

    return defaultValue ?? '';
  }

  String get environment => get('APP_ENV', defaultValue: 'development');

  String get apiBaseUrl {
    final env = environment;
    if (env == 'development') {
      return get('DEV_API_URL',
          defaultValue: 'https://elderwise-dev.elginbrian.com/api/v1');
    } else if (env == 'production') {
      return get('PROD_API_URL',
          defaultValue: 'https://elderwise-prod.elginbrian.com/api/v1');
    }
    return 'http://localhost:8080/api/v1';
  }
}

final appConfig = AppConfig();
