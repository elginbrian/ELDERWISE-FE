import 'dart:io';
import 'package:elderwise/data/api/env_config.dart';
import 'package:elderwise/data/api/api_config.dart';
import 'package:elderwise/domain/entities/uploaded_image.dart';
import 'package:elderwise/domain/enums/entity_type.dart';
import 'package:elderwise/domain/repositories/image_repository.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ImageRepositoryImpl implements ImageRepository {
  final SupabaseClient _supabase;
  final String _bucketName;

  ImageRepositoryImpl({
    SupabaseClient? supabase,
    String? bucketName,
  })  : _supabase = supabase ?? Supabase.instance.client,
        _bucketName = bucketName ?? appConfig.supabaseBucketName;

  @override
  Future<UploadedImage> uploadImage({
    required File file,
    required String fileName,
    String? userId,
    String? entityId,
    EntityType? entityType,
  }) async {
    try {
      final uuid = const Uuid().v4();
      final fileExt = path.extension(fileName);
      final uniqueFileName = '$uuid$fileExt';

      final String filePath = entityType != null
          ? '${entityType.toStringValue()}/$uniqueFileName'
          : 'general/$uniqueFileName';

      final mimeType = lookupMimeType(fileName) ?? 'application/octet-stream';

      await _supabase.storage.from(_bucketName).upload(
            filePath,
            file,
            fileOptions: FileOptions(
              contentType: mimeType,
              upsert: true,
            ),
          );

      final String imageUrl =
          _supabase.storage.from(_bucketName).getPublicUrl(filePath);

      final uploadedImage = UploadedImage(
        id: uuid,
        url: imageUrl,
        path: filePath,
        createdAt: DateTime.now(),
        userId: userId,
        entityId: entityId,
        entityType: entityType,
      );

      debugPrint("Image uploaded successfully: $imageUrl");
      return uploadedImage;
    } catch (e) {
      debugPrint("Error uploading image: $e");
      throw Exception('Failed to upload image: $e');
    }
  }

  @override
  Future<List<UploadedImage>> getImagesByEntity({
    required String entityId,
    required EntityType entityType,
  }) async {
    try {
      final String folderPath = entityType.toStringValue();
      final List<FileObject> files =
          await _supabase.storage.from(_bucketName).list(path: folderPath);

      final List<UploadedImage> images = [];

      for (final file in files) {
        final String filePath = '$folderPath/${file.name}';
        final String imageUrl =
            _supabase.storage.from(_bucketName).getPublicUrl(filePath);

        images.add(UploadedImage(
          id: path.basenameWithoutExtension(file.name),
          url: imageUrl,
          path: filePath,
          createdAt:
              file.createdAt != null ? DateTime.parse(file.createdAt!) : null,
          entityId: entityId,
          entityType: entityType,
        ));
      }

      return images;
    } catch (e) {
      debugPrint("Error retrieving images: $e");
      throw Exception('Failed to retrieve images: $e');
    }
  }

  @override
  Future<bool> deleteImage(String path) async {
    try {
      await _supabase.storage.from(_bucketName).remove([path]);

      debugPrint("Image deleted successfully: $path");
      return true;
    } catch (e) {
      debugPrint("Error deleting image: $e");
      return false;
    }
  }

  @override
  Future<UploadedImage> processEntityImage({
    required String imageUrl,
    required String entityId,
    required EntityType entityType,
    String? userId,
    String? imagePath,
    String? imageId,
  }) async {
    if (userId == null || userId.isEmpty) {
      throw Exception('User ID must be provided');
    }
    try {
      final Map<String, dynamic> requestData = {
        'url': imageUrl,
        'entityId': entityId,
        'entityType': entityType.toStringValue(),
        'userId': userId,
        if (imageId != null) 'id': imageId,
        if (imagePath != null) 'path': imagePath,
      };

      debugPrint("Processing image with data: $requestData");

      final response = await ApiConfig.dio.post(
        ApiConfig.processEntityImage,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        final data = responseData['data'] ?? responseData;

        return UploadedImage(
          id: data['id'] ?? imageId ?? const Uuid().v4(),
          url: data['url'] ?? imageUrl,
          path: data['path'] ?? imagePath ?? '',
          createdAt: data['created_at'] != null
              ? DateTime.parse(data['created_at'])
              : DateTime.now(),
          userId: userId,
          entityId: entityId,
          entityType: entityType,
        );
      } else {
        throw Exception('Failed to process image: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error processing entity image: $e");
      throw Exception('Failed to process entity image: $e');
    }
  }
}
