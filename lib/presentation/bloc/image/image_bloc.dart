import 'package:bloc/bloc.dart';
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
}
