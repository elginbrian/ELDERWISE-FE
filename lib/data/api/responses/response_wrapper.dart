class ResponseWrapper {
  final bool success;
  final String message;
  final dynamic data;
  final dynamic error;

  ResponseWrapper({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory ResponseWrapper.fromJson(Map<String, dynamic> json) {
    return ResponseWrapper(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {
      'success': success,
      'message': message,
    };

    if (data != null) {
      result['data'] = data;
    }

    if (error != null) {
      result['error'] = error;
    }

    return result;
  }
}
