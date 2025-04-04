class LocationHistoryPoint {
  final String pointId;
  final String locationHistoryId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LocationHistoryPoint({
    required this.pointId,
    required this.locationHistoryId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory LocationHistoryPoint.fromJson(Map<String, dynamic> json) {
    return LocationHistoryPoint(
      pointId: json['point_id'] as String,
      locationHistoryId: json['location_history_id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'point_id': pointId,
      'location_history_id': locationHistoryId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
