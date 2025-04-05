import 'package:flutter/material.dart';

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

  factory LocationHistoryPoint.fromJson(dynamic json) {
    debugPrint(
        'LocationHistoryPoint.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        final requiredFields = [
          'point_id',
          'location_history_id',
          'latitude',
          'longitude',
          'timestamp'
        ];

        for (final field in requiredFields) {
          if (!json.containsKey(field)) {
            throw FormatException(
                'Missing required field: $field in location history point data: $json');
          }
        }

        return LocationHistoryPoint(
          pointId: json['point_id'] as String,
          locationHistoryId: json['location_history_id'] as String,
          latitude: (json['latitude'] as num).toDouble(),
          longitude: (json['longitude'] as num).toDouble(),
          timestamp: DateTime.parse(json['timestamp'] as String),
        );
      } else {
        throw FormatException(
            'Unsupported JSON format for location history point: $json');
      }
    } catch (e) {
      debugPrint('Error in LocationHistoryPoint.fromJson: $e');
      rethrow;
    }
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
