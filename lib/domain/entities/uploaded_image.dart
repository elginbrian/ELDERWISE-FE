import 'package:elderwise/domain/enums/entity_type.dart';

class UploadedImage {
  final String id;
  final String url;
  final String path;
  final DateTime? createdAt;
  final String? userId;
  final String? entityId;
  final EntityType? entityType;

  UploadedImage({
    required this.id,
    required this.url,
    required this.path,
    this.createdAt,
    this.userId,
    this.entityId,
    this.entityType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'path': path,
      'created_at': createdAt?.toIso8601String(),
      'user_id': userId,
      'entity_id': entityId,
      'entity_type': entityType?.toStringValue(),
    };
  }

  factory UploadedImage.fromJson(Map<String, dynamic> json) {
    return UploadedImage(
      id: json['id'],
      url: json['url'],
      path: json['path'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      userId: json['user_id'],
      entityId: json['entity_id'],
      entityType: EntityType.fromString(json['entity_type']),
    );
  }
}
