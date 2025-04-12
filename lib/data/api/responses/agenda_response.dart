import 'package:elderwise/domain/entities/agenda.dart';
import 'package:flutter/material.dart';

class AgendaResponseDTO {
  final Agenda agenda;

  AgendaResponseDTO({
    required this.agenda,
  });

  factory AgendaResponseDTO.fromJson(dynamic json) {
    debugPrint('AgendaResponseDTO.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        if (json.containsKey('agenda') &&
            json['agenda'] is Map<String, dynamic>) {
          return AgendaResponseDTO(
            agenda: Agenda.fromJson(json['agenda'] as Map<String, dynamic>),
          );
        } else {
          throw FormatException(
              'Missing or invalid agenda field in response: $json');
        }
      } else {
        throw FormatException('Unsupported JSON format for agenda: $json');
      }
    } catch (e) {
      debugPrint('Error in AgendaResponseDTO.fromJson: $e');
      rethrow;
    }
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

  factory AgendasResponseDTO.fromJson(dynamic json) {
    debugPrint('AgendasResponseDTO.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        if (json.containsKey('agendas')) {
          var agendasJson = json['agendas'] as List<dynamic>? ?? [];
          List<Agenda> agendasList = agendasJson.map((item) {
            if (item is Map<String, dynamic>) {
              return Agenda.fromJson(item);
            } else {
              throw FormatException('Invalid agenda item format: $item');
            }
          }).toList();

          return AgendasResponseDTO(
            agendas: agendasList,
          );
        } else {
          throw FormatException('Missing agendas field in response: $json');
        }
      } else {
        throw FormatException(
            'Unsupported JSON format for agendas list: $json');
      }
    } catch (e) {
      debugPrint('Error in AgendasResponseDTO.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'agendas': agendas.map((agenda) => agenda.toJson()).toList(),
    };
  }
}
