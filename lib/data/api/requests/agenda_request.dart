class AgendaRequestDTO {
  final String elderId;
  final String caregiverId;
  final String category;
  final String content1;
  final String? content2;
  final String datetime;
  final bool isFinished;

  AgendaRequestDTO({
    required this.elderId,
    required this.caregiverId,
    required this.category,
    required this.content1,
    this.content2,
    required this.datetime,
    required this.isFinished,
  });

  factory AgendaRequestDTO.fromJson(Map<String, dynamic> json) {
    return AgendaRequestDTO(
      elderId: json['elder_id'] as String,
      caregiverId: json['caregiver_id'] as String,
      category: json['category'] as String,
      content1: json['content1'] as String,
      content2: json['content2'] as String?,
      datetime: json['datetime'] as String,
      isFinished: json['is_finished'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'elder_id': elderId,
      'caregiver_id': caregiverId,
      'category': category,
      'content1': content1,
      'datetime':
          datetime, // No conversion needed now, already a formatted string
      'is_finished': isFinished,
    };

    // Include content2 only if it's not null
    if (content2 != null) {
      data['content2'] = content2;
    }

    return data;
  }
}
