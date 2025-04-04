import 'package:elderwise/domain/entities/caregiver.dart';

class CaregiversResponseDTO {
  final List<Caregiver> caregivers;

  CaregiversResponseDTO({
    required this.caregivers,
  });

  factory CaregiversResponseDTO.fromJson(Map<String, dynamic> json) {
    var caregiversJson = json['caregivers'] as List<dynamic>? ?? [];
    List<Caregiver> caregiversList = caregiversJson
        .map((item) => Caregiver.fromJson(item as Map<String, dynamic>))
        .toList();

    return CaregiversResponseDTO(
      caregivers: caregiversList,
    );
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

  factory CaregiverResponseDTO.fromJson(Map<String, dynamic> json) {
    return CaregiverResponseDTO(
      caregiver: Caregiver.fromJson(json['caregiver'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caregiver': caregiver.toJson(),
    };
  }
}
