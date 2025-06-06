import 'dart:io';
import 'package:elderwise/domain/entities/uploaded_image.dart';
import 'package:elderwise/domain/enums/entity_type.dart';

abstract class ImageRepository {
  Future<UploadedImage> uploadImage({
    required File file,
    required String fileName,
    String? userId,
    String? entityId,
    required EntityType entityType,
  });

  Future<List<UploadedImage>> getImagesByEntity({
    required String entityId,
    required EntityType entityType,
  });

  Future<bool> deleteImage(String path);

  Future<UploadedImage> processEntityImage({
    required String imageUrl,
    required String entityId,
    required EntityType entityType,
    String? userId,
    String? imagePath,
    String? imageId,
  });
}
