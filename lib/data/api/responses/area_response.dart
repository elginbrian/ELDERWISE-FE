import 'package:elderwise/domain/entities/area.dart';

class AreaResponseDTO {
  final Area area;

  AreaResponseDTO({
    required this.area,
  });

  factory AreaResponseDTO.fromJson(Map<String, dynamic> json) {
    return AreaResponseDTO(
      area: Area.fromJson(json['area'] as Map<String, dynamic>),
    );
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

  factory AreasResponseDTO.fromJson(Map<String, dynamic> json) {
    var areasJson = json['areas'] as List<dynamic>? ?? [];
    List<Area> areasList = areasJson
        .map((item) => Area.fromJson(item as Map<String, dynamic>))
        .toList();
    return AreasResponseDTO(
      areas: areasList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'areas': areas.map((area) => area.toJson()).toList(),
    };
  }
}
