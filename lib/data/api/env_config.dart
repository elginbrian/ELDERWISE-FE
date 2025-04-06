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
    'SUPABASE_URL': 'https://ucayizjdmgxgwweshzag.supabase.co',
    'SUPABASE_ANON_KEY':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVjYXlpempkbWd4Z3d3ZXNoemFnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM3NjQwMTgsImV4cCI6MjA1OTM0MDAxOH0.pwFn0khq87rxYRim1lQezFMbot34dSp1xq-8h6XFV0o',
    'SUPABASE_BUCKET_NAME': 'elderwise-images',
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

  String get supabaseUrl => get('SUPABASE_URL',
      defaultValue: 'https://ucayizjdmgxgwweshzag.supabase.co');

  String get supabaseAnonKey => get('SUPABASE_ANON_KEY',
      defaultValue:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVjYXlpempkbWd4Z3d3ZXNoemFnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM3NjQwMTgsImV4cCI6MjA1OTM0MDAxOH0.pwFn0khq87rxYRim1lQezFMbot34dSp1xq-8h6XFV0o');

  String get supabaseBucketName =>
      get('SUPABASE_BUCKET_NAME', defaultValue: 'elderwise-images');
}

final appConfig = AppConfig();
