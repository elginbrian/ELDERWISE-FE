import 'dart:io';
import 'package:elderwise/domain/enums/entity_type.dart';
import 'package:elderwise/presentation/bloc/image/image_bloc.dart';
import 'package:elderwise/presentation/bloc/image/image_event.dart';
import 'package:elderwise/presentation/bloc/image/image_state.dart';
import 'package:elderwise/presentation/services/image_picker_service.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;

class ImageUploadWidget extends StatefulWidget {
  final String? userId;
  final String? entityId;
  final EntityType? entityType;
  final Function(String imageUrl)? onImageUploaded;
  final String? currentImageUrl;

  const ImageUploadWidget({
    super.key,
    this.userId,
    this.entityId,
    this.entityType,
    this.onImageUploaded,
    this.currentImageUrl,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final _imagePickerService = ImagePickerService();
  File? _imageFile;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageBloc, ImageState>(
      listener: (context, state) {
        if (state is ImageUploadSuccess) {
          setState(() {
            _isUploading = false;
          });
          if (widget.onImageUploaded != null) {
            widget.onImageUploaded!(state.uploadedImage.url);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image uploaded successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ImageFailure) {
          setState(() {
            _isUploading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to upload image: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Column(
        children: [
          GestureDetector(
            onTap: _showImagePickerOptions,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.neutral20,
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: AppColors.primaryMain,
                  width: 2,
                ),
              ),
              child: _buildImageContent(),
            ),
          ),
          const SizedBox(height: 8),
          _isUploading
              ? const CircularProgressIndicator()
              : TextButton(
                  onPressed: _showImagePickerOptions,
                  child: const Text('Change Image'),
                ),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    if (_isUploading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(58),
        child: Image.file(
          _imageFile!,
          fit: BoxFit.cover,
          width: 116,
          height: 116,
        ),
      );
    } else if (widget.currentImageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(58),
        child: Image.network(
          widget.currentImageUrl!,
          fit: BoxFit.cover,
          width: 116,
          height: 116,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person,
              size: 60,
              color: AppColors.primaryMain,
            );
          },
        ),
      );
    } else {
      return const Icon(
        Icons.person,
        size: 60,
        color: AppColors.primaryMain,
      );
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  _pickImageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final File? pickedImage = await _imagePickerService.pickImageFromGallery();
    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
      _uploadImage(pickedImage);
    }
  }

  Future<void> _pickImageFromCamera() async {
    final File? pickedImage = await _imagePickerService.pickImageFromCamera();
    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
      _uploadImage(pickedImage);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    if (imageFile.path.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    final fileName = path.basename(imageFile.path);

    context.read<ImageBloc>().add(
          UploadImageEvent(
            file: imageFile,
            fileName: fileName,
            userId: widget.userId,
            entityId: widget.entityId,
            entityType: widget.entityType,
          ),
        );
  }
}
