import 'package:elderwise/domain/entities/uploaded_image.dart';

abstract class ImageState {}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageUploadSuccess extends ImageState {
  final UploadedImage uploadedImage;

  ImageUploadSuccess(this.uploadedImage);
}

class ImageListSuccess extends ImageState {
  final List<UploadedImage> images;

  ImageListSuccess(this.images);
}

class ImageDeleteSuccess extends ImageState {
  final bool success;
  final String path;

  ImageDeleteSuccess(this.success, this.path);
}

class ImageFailure extends ImageState {
  final String error;

  ImageFailure(this.error);
}

class ImageProcessSuccess extends ImageState {
  final UploadedImage image;

  ImageProcessSuccess(this.image);
}
