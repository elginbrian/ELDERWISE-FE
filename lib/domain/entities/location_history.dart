import 'package:elderwise/domain/entities/location_history_point.dart';

class LocationHistory {
  final String locationHistoryId;
  final String elderId;
  final String caregiverId;
  final DateTime createdAt;
  final List<LocationHistoryPoint> points;

  LocationHistory({
    required this.locationHistoryId,
    required this.elderId,
    required this.caregiverId,
    required this.createdAt,
    required this.points,
  });

  factory LocationHistory.fromJson(Map<String, dynamic> json) {
    var pointsJson = json['points'] as List<dynamic>? ?? [];
    List<LocationHistoryPoint> pointsList = pointsJson
        .map((point) =>
            LocationHistoryPoint.fromJson(point as Map<String, dynamic>))
        .toList();

    return LocationHistory(
      locationHistoryId: json['location_history_id'] as String,
      elderId: json['elder_id'] as String,
      caregiverId: json['caregiver_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      points: pointsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location_history_id': locationHistoryId,
      'elder_id': elderId,
      'caregiver_id': caregiverId,
      'created_at': createdAt.toIso8601String(),
      'points': points.map((point) => point.toJson()).toList(),
    };
  }
}
