import 'package:elderwise/domain/entities/location_history_point.dart';
import 'package:flutter/material.dart';

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

  factory LocationHistory.fromJson(dynamic json) {
    debugPrint('LocationHistory.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        final requiredFields = ['location_history_id', 'elder_id'];

        for (final field in requiredFields) {
          if (!json.containsKey(field)) {
            throw FormatException(
                'Missing required field: $field in location history data: $json');
          }
        }

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
      } else {
        throw FormatException(
            'Unsupported JSON format for location history: $json');
      }
    } catch (e) {
      debugPrint('Error in LocationHistory.fromJson: $e');
      rethrow;
    }
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
