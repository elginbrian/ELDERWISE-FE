import 'package:elderwise/domain/entities/emergency_alert.dart';
import 'package:flutter/material.dart';

class EmergencyAlertResponseDTO {
  final EmergencyAlert emergencyAlert;

  EmergencyAlertResponseDTO({
    required this.emergencyAlert,
  });

  factory EmergencyAlertResponseDTO.fromJson(dynamic json) {
    debugPrint(
        'EmergencyAlertResponseDTO.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        if (json.containsKey('emergency_alert') &&
            json['emergency_alert'] is Map<String, dynamic>) {
          return EmergencyAlertResponseDTO(
            emergencyAlert: EmergencyAlert.fromJson(
              json['emergency_alert'] as Map<String, dynamic>,
            ),
          );
        } else {
          throw FormatException(
              'Missing or invalid emergency_alert field in response: $json');
        }
      } else {
        throw FormatException(
            'Unsupported JSON format for emergency alert: $json');
      }
    } catch (e) {
      debugPrint('Error in EmergencyAlertResponseDTO.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'emergency_alert': emergencyAlert.toJson(),
    };
  }
}
