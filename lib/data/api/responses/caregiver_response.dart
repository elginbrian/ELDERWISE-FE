import 'package:elderwise/domain/entities/caregiver.dart';
import 'package:flutter/material.dart';

class CaregiversResponseDTO {
  final List<Caregiver> caregivers;

  CaregiversResponseDTO({
    required this.caregivers,
  });

  factory CaregiversResponseDTO.fromJson(dynamic json) {
    debugPrint(
        'CaregiversResponseDTO.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        if (json.containsKey('caregivers')) {
          var caregiversJson = json['caregivers'] as List<dynamic>? ?? [];
          List<Caregiver> caregiversList = caregiversJson.map((item) {
            if (item is Map<String, dynamic>) {
              return Caregiver.fromJson(item);
            } else {
              throw FormatException('Invalid caregiver item format: $item');
            }
          }).toList();

          return CaregiversResponseDTO(
            caregivers: caregiversList,
          );
        } else {
          throw FormatException('Missing caregivers field in response: $json');
        }
      } else {
        throw FormatException(
            'Unsupported JSON format for caregivers list: $json');
      }
    } catch (e) {
      debugPrint('Error in CaregiversResponseDTO.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'caregivers': caregivers.map((caregiver) => caregiver.toJson()).toList(),
    };
  }
}

class CaregiverResponseDTO {
  final Caregiver caregiver;

  CaregiverResponseDTO({
    required this.caregiver,
  });

  factory CaregiverResponseDTO.fromJson(dynamic json) {
    debugPrint(
        'CaregiverResponseDTO.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        if (json.containsKey('caregiver') &&
            json['caregiver'] is Map<String, dynamic>) {
          return CaregiverResponseDTO(
            caregiver:
                Caregiver.fromJson(json['caregiver'] as Map<String, dynamic>),
          );
        } else {
          throw FormatException(
              'Missing or invalid caregiver field in response: $json');
        }
      } else {
        throw FormatException('Unsupported JSON format for caregiver: $json');
      }
    } catch (e) {
      debugPrint('Error in CaregiverResponseDTO.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'caregiver': caregiver.toJson(),
    };
  }
}
