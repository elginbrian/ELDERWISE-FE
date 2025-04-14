class LocationHistoryRequestDTO {
  final String elderId;
  final String caregiverId;
  final DateTime? createdAt;

  LocationHistoryRequestDTO({
    required this.elderId,
    required this.caregiverId,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'elder_id': elderId,
      'caregiver_id': caregiverId,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}

class LocationHistoryPointRequestDTO {
  final String locationHistoryId;
  final double latitude;
  final double longitude;
  final DateTime? timestamp;

  LocationHistoryPointRequestDTO({
    required this.locationHistoryId,
    required this.latitude,
    required this.longitude,
    this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'location_history_id': locationHistoryId,
      'latitude': latitude,
      'longitude': longitude,
      if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
    };
  }
}
