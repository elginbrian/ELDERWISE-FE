import 'package:elderwise/domain/entities/elder.dart';

class EldersResponseDTO {
  final List<Elder> elders;

  EldersResponseDTO({
    required this.elders,
  });

  factory EldersResponseDTO.fromJson(Map<String, dynamic> json) {
    var eldersJson = json['elders'] as List<dynamic>? ?? [];
    List<Elder> eldersList = eldersJson
        .map((item) => Elder.fromJson(item as Map<String, dynamic>))
        .toList();

    return EldersResponseDTO(
      elders: eldersList,
    );
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

  factory ElderResponseDTO.fromJson(Map<String, dynamic> json) {
    return ElderResponseDTO(
      elder: Elder.fromJson(json['elder'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'elder': elder.toJson(),
    };
  }
}
