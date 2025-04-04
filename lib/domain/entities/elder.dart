class Elder {
  final String elderId;
  final String userId;
  final String name;
  final DateTime birthdate;
  final String gender;
  final double bodyHeight;
  final double bodyWeight;
  final String photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Elder({
    required this.elderId,
    required this.userId,
    required this.name,
    required this.birthdate,
    required this.gender,
    required this.bodyHeight,
    required this.bodyWeight,
    required this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Elder.fromJson(Map<String, dynamic> json) {
    return Elder(
      elderId: json['elder_id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      birthdate: DateTime.parse(json['birthdate'] as String),
      gender: json['gender'] as String,
      bodyHeight: (json['body_height'] as num).toDouble(),
      bodyWeight: (json['body_weight'] as num).toDouble(),
      photoUrl: json['photo_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'elder_id': elderId,
      'user_id': userId,
      'name': name,
      'birthdate': birthdate.toIso8601String(),
      'gender': gender,
      'body_height': bodyHeight,
      'body_weight': bodyWeight,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
