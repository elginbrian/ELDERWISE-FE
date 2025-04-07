import 'package:bloc/bloc.dart';
import 'package:elderwise/domain/entities/uploaded_image.dart';
import 'package:elderwise/domain/enums/entity_type.dart';
import 'package:elderwise/domain/repositories/image_repository.dart';
import 'package:elderwise/presentation/bloc/image/image_event.dart';
import 'package:elderwise/presentation/bloc/image/image_state.dart';
import 'package:flutter/material.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageRepository imageRepository;

  ImageBloc(this.imageRepository) : super(ImageInitial()) {
    on<UploadImageEvent>(_onUploadImage);
    on<GetEntityImagesEvent>(_onGetEntityImages);
    on<DeleteImageEvent>(_onDeleteImage);
    on<ProcessEntityImageEvent>(_onProcessEntityImage);
  }

  Future<void> _onUploadImage(
      UploadImageEvent event, Emitter<ImageState> emit) async {
    emit(ImageLoading());
    try {
      final uploadedImage = await imageRepository.uploadImage(
        file: event.file,
        fileName: event.fileName,
        userId: event.userId,
        entityId: event.entityId,
        entityType: event.entityType,
      );

      emit(ImageUploadSuccess(uploadedImage));

      if (event.entityId != null && event.entityType != null) {
        add(ProcessEntityImageEvent(
          imageUrl: uploadedImage.url,
          entityId: event.entityId!,
          entityType: event.entityType!,
          userId: event.userId,
          imagePath: uploadedImage.path,
          imageId: uploadedImage.id,
        ));
      }
    } catch (e) {
      debugPrint('Image upload exception: $e');
      emit(ImageFailure(e.toString()));
    }
  }

  Future<void> _onGetEntityImages(
      GetEntityImagesEvent event, Emitter<ImageState> emit) async {
    emit(ImageLoading());
    try {
      final images = await imageRepository.getImagesByEntity(
        entityId: event.entityId,
        entityType: event.entityType,
      );

      emit(ImageListSuccess(images));
    } catch (e) {
      debugPrint('Get entity images exception: $e');
      emit(ImageFailure(e.toString()));
    }
  }

  Future<void> _onDeleteImage(
      DeleteImageEvent event, Emitter<ImageState> emit) async {
    emit(ImageLoading());
    try {
      final success = await imageRepository.deleteImage(event.path);

      emit(ImageDeleteSuccess(success, event.path));
    } catch (e) {
      debugPrint('Delete image exception: $e');
      emit(ImageFailure(e.toString()));
    }
  }

  Future<void> _onProcessEntityImage(
      ProcessEntityImageEvent event, Emitter<ImageState> emit) async {
    emit(ImageLoading());
    try {
      final processedImage = await imageRepository.processEntityImage(
        imageUrl: event.imageUrl,
        entityId: event.entityId,
        entityType: event.entityType,
        userId: event.userId,
        imagePath: event.imagePath,
        imageId: event.imageId,
      );

      final verifiedImage = _verifyImageData(
          processedImage, event.userId, event.entityId, event.entityType);

      emit(ImageProcessSuccess(verifiedImage));
    } catch (e) {
      debugPrint('Process entity image exception: $e');
      emit(ImageFailure(e.toString()));
    }
  }

  UploadedImage _verifyImageData(
    UploadedImage image,
    String? userId,
    String entityId,
    EntityType entityType,
  ) {
    if (image.userId == null ||
        image.entityId == null ||
        image.entityType == null) {
      return UploadedImage(
        id: image.id,
        url: image.url,
        path: image.path,
        createdAt: image.createdAt,
        userId: userId,
        entityId: entityId,
        entityType: entityType,
      );
    }
    return image;
  }
}
