import 'package:elderwise/domain/entities/agenda.dart';

class AgendaResponseDTO {
  final Agenda agenda;

  AgendaResponseDTO({
    required this.agenda,
  });

  factory AgendaResponseDTO.fromJson(Map<String, dynamic> json) {
    return AgendaResponseDTO(
      agenda: Agenda.fromJson(json['agenda'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'agenda': agenda.toJson(),
    };
  }
}

class AgendasResponseDTO {
  final List<Agenda> agendas;

  AgendasResponseDTO({
    required this.agendas,
  });

  factory AgendasResponseDTO.fromJson(Map<String, dynamic> json) {
    var agendasJson = json['agendas'] as List<dynamic>? ?? [];
    List<Agenda> agendasList = agendasJson
        .map((item) => Agenda.fromJson(item as Map<String, dynamic>))
        .toList();

    return AgendasResponseDTO(
      agendas: agendasList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'agendas': agendas.map((agenda) => agenda.toJson()).toList(),
    };
  }
}
