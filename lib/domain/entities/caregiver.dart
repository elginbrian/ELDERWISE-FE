class Caregiver {
  final String caregiverId;
  final String userId;
  final String name;
  final DateTime birthdate;
  final String gender;
  final String phoneNumber;
  final String profileUrl;
  final String relationship;
  final DateTime createdAt;
  final DateTime updatedAt;

  Caregiver({
    required this.caregiverId,
    required this.userId,
    required this.name,
    required this.birthdate,
    required this.gender,
    required this.phoneNumber,
    required this.profileUrl,
    required this.relationship,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Caregiver.fromJson(Map<String, dynamic> json) {
    return Caregiver(
      caregiverId: json['caregiver_id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      birthdate: DateTime.parse(json['birthdate'] as String),
      gender: json['gender'] as String,
      phoneNumber: json['phone_number'] as String,
      profileUrl: json['profile_url'] as String,
      relationship: json['relationship'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caregiver_id': caregiverId,
      'user_id': userId,
      'name': name,
      'birthdate': birthdate.toIso8601String(),
      'gender': gender,
      'phone_number': phoneNumber,
      'profile_url': profileUrl,
      'relationship': relationship,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
