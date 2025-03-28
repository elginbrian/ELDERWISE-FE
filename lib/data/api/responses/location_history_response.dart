import 'package:elderwise/domain/entities/location_history.dart';
import 'package:elderwise/domain/entities/location_history_point.dart';

class LocationHistoryResponseDTO {
  final LocationHistory locationHistory;

  LocationHistoryResponseDTO({
    required this.locationHistory,
  });

  factory LocationHistoryResponseDTO.fromJson(Map<String, dynamic> json) {
    return LocationHistoryResponseDTO(
      locationHistory: LocationHistory.fromJson(
        json['location_history'] as Map<String, dynamic>,
      ),
    );
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

  factory LocationHistoryPointsResponseDTO.fromJson(Map<String, dynamic> json) {
    var pointsJson = json['points'] as List<dynamic>? ?? [];
    List<LocationHistoryPoint> pointsList = pointsJson
        .map((item) =>
            LocationHistoryPoint.fromJson(item as Map<String, dynamic>))
        .toList();

    return LocationHistoryPointsResponseDTO(
      points: pointsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'points': points.map((point) => point.toJson()).toList(),
    };
  }
}
