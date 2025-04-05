import 'package:flutter/material.dart';

class EmergencyAlert {
  final String emergencyAlertId;
  final String elderId;
  final String caregiverId;
  final DateTime datetime;
  final double elderLat;
  final double elderLong;
  final bool isDismissed;

  EmergencyAlert({
    required this.emergencyAlertId,
    required this.elderId,
    required this.caregiverId,
    required this.datetime,
    required this.elderLat,
    required this.elderLong,
    required this.isDismissed,
  });

  factory EmergencyAlert.fromJson(dynamic json) {
    debugPrint('EmergencyAlert.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        final requiredFields = [
          'emergency_alert_id',
          'elder_id',
          'caregiver_id',
          'datetime',
          'elder_lat',
          'elder_long',
          'is_dismissed'
        ];

        for (final field in requiredFields) {
          if (!json.containsKey(field)) {
            throw FormatException(
                'Missing required field: $field in emergency alert data: $json');
          }
        }

        return EmergencyAlert(
          emergencyAlertId: json['emergency_alert_id'] as String,
          elderId: json['elder_id'] as String,
          caregiverId: json['caregiver_id'] as String,
          datetime: DateTime.parse(json['datetime'] as String),
          elderLat: (json['elder_lat'] as num).toDouble(),
          elderLong: (json['elder_long'] as num).toDouble(),
          isDismissed: json['is_dismissed'] as bool,
        );
      } else {
        throw FormatException(
            'Unsupported JSON format for emergency alert: $json');
      }
    } catch (e) {
      debugPrint('Error in EmergencyAlert.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'emergency_alert_id': emergencyAlertId,
      'elder_id': elderId,
      'caregiver_id': caregiverId,
      'datetime': datetime.toIso8601String(),
      'elder_lat': elderLat,
      'elder_long': elderLong,
      'is_dismissed': isDismissed,
    };
  }
}
