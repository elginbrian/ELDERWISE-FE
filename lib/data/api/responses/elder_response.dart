import 'package:elderwise/domain/entities/elder.dart';
import 'package:flutter/material.dart';

class EldersResponseDTO {
  final List<Elder> elders;

  EldersResponseDTO({
    required this.elders,
  });

  factory EldersResponseDTO.fromJson(dynamic json) {
    debugPrint('EldersResponseDTO.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        if (json.containsKey('elders')) {
          var eldersJson = json['elders'] as List<dynamic>? ?? [];
          List<Elder> eldersList = eldersJson.map((item) {
            if (item is Map<String, dynamic>) {
              return Elder.fromJson(item);
            } else {
              throw FormatException('Invalid elder item format: $item');
            }
          }).toList();

          return EldersResponseDTO(
            elders: eldersList,
          );
        } else {
          throw FormatException('Missing elders field in response: $json');
        }
      } else {
        throw FormatException('Unsupported JSON format for elders list: $json');
      }
    } catch (e) {
      debugPrint('Error in EldersResponseDTO.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'elders': elders.map((elder) => elder.toJson()).toList(),
    };
  }
}

class ElderResponseDTO {
  final Elder elder;

  ElderResponseDTO({
    required this.elder,
  });

  factory ElderResponseDTO.fromJson(dynamic json) {
    debugPrint('ElderResponseDTO.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        if (json.containsKey('elder') &&
            json['elder'] is Map<String, dynamic>) {
          return ElderResponseDTO(
            elder: Elder.fromJson(json['elder'] as Map<String, dynamic>),
          );
        } else {
          throw FormatException(
              'Missing or invalid elder field in response: $json');
        }
      } else {
        throw FormatException('Unsupported JSON format for elder: $json');
      }
    } catch (e) {
      debugPrint('Error in ElderResponseDTO.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'elder': elder.toJson(),
    };
  }
}
