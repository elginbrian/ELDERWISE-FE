import 'package:elderwise/domain/entities/location_history.dart';
import 'package:elderwise/domain/entities/location_history_point.dart';
import 'package:flutter/material.dart';

class LocationHistoryResponseDTO {
  final LocationHistory locationHistory;

  LocationHistoryResponseDTO({
    required this.locationHistory,
  });

  factory LocationHistoryResponseDTO.fromJson(dynamic json) {
    debugPrint(
        'LocationHistoryResponseDTO.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        if (json.containsKey('location_history') &&
            json['location_history'] is Map<String, dynamic>) {
          return LocationHistoryResponseDTO(
            locationHistory: LocationHistory.fromJson(
              json['location_history'] as Map<String, dynamic>,
            ),
          );
        } else {
          throw FormatException(
              'Missing or invalid location_history field in response: $json');
        }
      } else {
        throw FormatException(
            'Unsupported JSON format for location history: $json');
      }
    } catch (e) {
      debugPrint('Error in LocationHistoryResponseDTO.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'location_history': locationHistory.toJson(),
    };
  }
}

class LocationHistoryPointsResponseDTO {
  final List<LocationHistoryPoint> points;

  LocationHistoryPointsResponseDTO({
    required this.points,
  });

  factory LocationHistoryPointsResponseDTO.fromJson(dynamic json) {
    debugPrint(
        'LocationHistoryPointsResponseDTO.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        if (json.containsKey('points')) {
          var pointsJson = json['points'] as List<dynamic>? ?? [];
          List<LocationHistoryPoint> pointsList = pointsJson.map((item) {
            if (item is Map<String, dynamic>) {
              return LocationHistoryPoint.fromJson(item);
            } else {
              throw FormatException(
                  'Invalid location history point format: $item');
            }
          }).toList();

          return LocationHistoryPointsResponseDTO(
            points: pointsList,
          );
        } else {
          throw FormatException('Missing points field in response: $json');
        }
      } else {
        throw FormatException(
            'Unsupported JSON format for location history points list: $json');
      }
    } catch (e) {
      debugPrint('Error in LocationHistoryPointsResponseDTO.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'points': points.map((point) => point.toJson()).toList(),
    };
  }
}
