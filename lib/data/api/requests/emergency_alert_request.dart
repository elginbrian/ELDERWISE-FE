class EmergencyAlertRequestDTO {
  final String elderId;
  final String caregiverId;
  final DateTime datetime;
  final double elderLat;
  final double elderLong;
  final bool isDismissed;

  EmergencyAlertRequestDTO({
    required this.elderId,
    required this.caregiverId,
    required this.datetime,
    required this.elderLat,
    required this.elderLong,
    this.isDismissed = false,
  });

  factory EmergencyAlertRequestDTO.fromJson(Map<String, dynamic> json) {
    return EmergencyAlertRequestDTO(
      elderId: json['elder_id'] as String,
      caregiverId: json['caregiver_id'] as String,
      datetime: DateTime.parse(json['datetime'] as String),
      elderLat: (json['elder_lat'] as num).toDouble(),
      elderLong: (json['elder_long'] as num).toDouble(),
      isDismissed: json['is_dismissed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'elder_id': elderId,
      'caregiver_id': caregiverId,
      'datetime': datetime.toIso8601String(),
      'elder_lat': elderLat,
      'elder_long': elderLong,
      'is_dismissed': isDismissed,
    };
  }
}
