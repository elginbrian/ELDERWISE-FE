import 'dart:io';
import 'package:elderwise/domain/enums/entity_type.dart';

abstract class ImageEvent {}

class UploadImageEvent extends ImageEvent {
  final File file;
  final String fileName;
  final String? userId;
  final String? entityId;
  final EntityType? entityType;

  UploadImageEvent({
    required this.file,
    required this.fileName,
    this.userId,
    this.entityId,
    this.entityType,
  });
}

class GetEntityImagesEvent extends ImageEvent {
  final String entityId;
  final EntityType entityType;

  GetEntityImagesEvent({
    required this.entityId,
    required this.entityType,
  });
}

class DeleteImageEvent extends ImageEvent {
  final String path;

  DeleteImageEvent(this.path);
}

class ProcessEntityImageEvent extends ImageEvent {
  final String imageUrl;
  final String entityId;
  final EntityType entityType;
  final String? userId;
  final String? imagePath;
  final String? imageId;

  ProcessEntityImageEvent({
    required this.imageUrl,
    required this.entityId,
    required this.entityType,
    this.userId,
    this.imagePath,
    this.imageId,
  });
}
