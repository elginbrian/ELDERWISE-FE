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

  factory Agenda.fromJson(Map<String, dynamic> json) {
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
