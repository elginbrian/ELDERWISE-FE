import 'package:elderwise/domain/entities/area.dart';
import 'package:flutter/material.dart';

class AreaResponseDTO {
  final Area area;

  AreaResponseDTO({
    required this.area,
  });

  factory AreaResponseDTO.fromJson(dynamic json) {
    debugPrint('AreaResponseDTO.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        if (json.containsKey('area') && json['area'] is Map<String, dynamic>) {
          return AreaResponseDTO(
            area: Area.fromJson(json['area'] as Map<String, dynamic>),
          );
        } else {
          throw FormatException(
              'Missing or invalid area field in response: $json');
        }
      } else {
        throw FormatException('Unsupported JSON format for area: $json');
      }
    } catch (e) {
      debugPrint('Error in AreaResponseDTO.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'area': area.toJson(),
    };
  }
}

class AreasResponseDTO {
  final List<Area> areas;

  AreasResponseDTO({
    required this.areas,
  });

  factory AreasResponseDTO.fromJson(dynamic json) {
    debugPrint('AreasResponseDTO.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        if (json.containsKey('areas')) {
          var areasJson = json['areas'] as List<dynamic>? ?? [];
          List<Area> areasList = areasJson.map((item) {
            if (item is Map<String, dynamic>) {
              return Area.fromJson(item);
            } else {
              throw FormatException('Invalid area item format: $item');
            }
          }).toList();

          return AreasResponseDTO(
            areas: areasList,
          );
        } else {
          throw FormatException('Missing areas field in response: $json');
        }
      } else {
        throw FormatException('Unsupported JSON format for areas list: $json');
      }
    } catch (e) {
      debugPrint('Error in AreasResponseDTO.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'areas': areas.map((area) => area.toJson()).toList(),
    };
  }
}
