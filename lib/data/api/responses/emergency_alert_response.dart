import 'package:elderwise/domain/entities/emergency_alert.dart';

class EmergencyAlertResponseDTO {
  final EmergencyAlert emergencyAlert;

  EmergencyAlertResponseDTO({
    required this.emergencyAlert,
  });

  factory EmergencyAlertResponseDTO.fromJson(Map<String, dynamic> json) {
    return EmergencyAlertResponseDTO(
      emergencyAlert: EmergencyAlert.fromJson(
        json['emergency_alert'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emergency_alert': emergencyAlert.toJson(),
    };
  }
}
