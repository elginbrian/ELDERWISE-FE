import 'package:flutter/material.dart';

class Agenda {
  final String agendaId;
  final String elderId;
  final String caregiverId;
  final String category;
  final String content1;
  final String content2;
  final DateTime datetime;
  final bool isFinished;
  final DateTime createdAt;
  final DateTime updatedAt;

  Agenda({
    required this.agendaId,
    required this.elderId,
    required this.caregiverId,
    required this.category,
    required this.content1,
    required this.content2,
    required this.datetime,
    required this.isFinished,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Agenda.fromJson(dynamic json) {
    debugPrint('Agenda.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        final requiredFields = [
          'agenda_id',
          'elder_id',
          'caregiver_id',
          'category',
          'content1',
          'content2',
          'datetime',
          'is_finished',
          'created_at',
          'updated_at'
        ];

        for (final field in requiredFields) {
          if (!json.containsKey(field)) {
            throw FormatException(
                'Missing required field: $field in agenda data: $json');
          }
        }

        return Agenda(
          agendaId: json['agenda_id'] as String,
          elderId: json['elder_id'] as String,
          caregiverId: json['caregiver_id'] as String,
          category: json['category'] as String,
          content1: json['content1'] as String,
          content2: json['content2'] as String,
          datetime: DateTime.parse(json['datetime'] as String),
          isFinished: json['is_finished'] as bool,
          createdAt: DateTime.parse(json['created_at'] as String),
          updatedAt: DateTime.parse(json['updated_at'] as String),
        );
      } else {
        throw FormatException('Unsupported JSON format for agenda: $json');
      }
    } catch (e) {
      debugPrint('Error in Agenda.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'agenda_id': agendaId,
      'elder_id': elderId,
      'caregiver_id': caregiverId,
      'category': category,
      'content1': content1,
      'content2': content2,
      'datetime': datetime.toIso8601String(),
      'is_finished': isFinished,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
