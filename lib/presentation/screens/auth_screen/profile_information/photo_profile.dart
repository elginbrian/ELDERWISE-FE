import 'dart:io';
import 'package:elderwise/domain/enums/entity_type.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_bloc.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_state.dart';
import 'package:elderwise/presentation/bloc/elder/elder_bloc.dart';
import 'package:elderwise/presentation/bloc/elder/elder_state.dart';
import 'package:elderwise/presentation/bloc/image/image_bloc.dart';
import 'package:elderwise/presentation/bloc/image/image_event.dart';
import 'package:elderwise/presentation/bloc/image/image_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:path/path.dart' as path;

class PhotoProfile extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool isFinalStep;
  final String userId;

  const PhotoProfile({
    super.key,
    required this.onNext,
    required this.onSkip,
    this.isFinalStep = false,
    required this.userId,
  });

  @override
  State<PhotoProfile> createState() => _PhotoProfileState();
}

class _PhotoProfileState extends State<PhotoProfile> {
  File? _elderImage;
  File? _caregiverImage;
  bool _isUploading = false;
  String? _elderId;
  String? _caregiverId;
  bool _elderPhotoUploaded = false;
  bool _caregiverPhotoUploaded = false;

  @override
  void initState() {
    super.initState();
    final elderState = context.read<ElderBloc>().state;
    final caregiverState = context.read<CaregiverBloc>().state;

    if (elderState is ElderSuccess) {
      _elderId = elderState.elder.elder.elderId;
    }

    if (caregiverState is CaregiverSuccess) {
      _caregiverId = caregiverState.caregiver.caregiver.caregiverId;
    }
  }

  Future<void> _pickImageFromGallery(bool isElder) async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage != null) {
      setState(() {
        if (isElder) {
          _elderImage = File(returnedImage.path);
        } else {
          _caregiverImage = File(returnedImage.path);
        }
      });
    }
  }

  void _savePhotos() {
    setState(() {
      _isUploading = true;
      _elderPhotoUploaded = false;
      _caregiverPhotoUploaded = false;
    });

    if (_elderImage != null && _elderId != null) {
      _uploadElderPhoto();
    } else {
      _elderPhotoUploaded = true;
    }

    if (_caregiverImage != null && _caregiverId != null) {
      _uploadCaregiverPhoto();
    } else {
      _caregiverPhotoUploaded = true;
    }

    if ((_elderImage == null || _elderId == null) &&
        (_caregiverImage == null || _caregiverId == null)) {
      _completeProcess();
    }
  }

  void _uploadElderPhoto() {
    final fileName =
        '${widget.userId}_elder_${path.basename(_elderImage!.path)}';
    context.read<ImageBloc>().add(UploadImageEvent(
          file: _elderImage!,
          fileName: fileName,
          userId: widget.userId,
          entityId: _elderId!,
          entityType: EntityType.elder,
        ));
  }

  void _uploadCaregiverPhoto() {
    final fileName =
        '${widget.userId}_caregiver_${path.basename(_caregiverImage!.path)}';
    context.read<ImageBloc>().add(UploadImageEvent(
          file: _caregiverImage!,
          fileName: fileName,
          userId: widget.userId,
          entityId: _caregiverId!,
          entityType: EntityType.caregiver,
        ));
  }

  void _checkCompletionStatus() {
    if (_elderPhotoUploaded && _caregiverPhotoUploaded) {
      _completeProcess();
    }
  }

  void _completeProcess() {
    setState(() {
      _isUploading = false;
    });
    widget.onNext();
  }

  Widget _buildProfileImage({
    required File? imageFile,
    required VoidCallback onTap,
    required String title,
    required bool isAvailable,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: isAvailable ? AppColors.neutral90 : AppColors.neutral50,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: isAvailable ? onTap : null,
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(75),
              border: Border.all(
                color: !isAvailable
                    ? AppColors.neutral30
                    : imageFile != null
                        ? AppColors.primaryMain
                        : AppColors.neutral70,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(75),
              child: imageFile != null
                  ? Image.file(imageFile, fit: BoxFit.cover)
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset("${iconImages}plus.png",
                            color: isAvailable ? null : AppColors.neutral30),
                        Positioned(
                          bottom: 30,
                          child: Text(
                            isAvailable
                                ? "Tap to add photo"
                                : "Profile not created",
                            style: TextStyle(
                              fontSize: 12,
                              color: isAvailable
                                  ? AppColors.neutral70
                                  : AppColors.neutral30,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ImageBloc, ImageState>(
          listener: (context, state) {
            if (state is ImageUploadSuccess) {
              if (state.uploadedImage.entityType.toString() == 'elder') {
                setState(() {
                  _elderPhotoUploaded = true;
                });
              } else if (state.uploadedImage.entityType.toString() ==
                  'caregiver') {
                setState(() {
                  _caregiverPhotoUploaded = true;
                });
              }

              _checkCompletionStatus();
            } else if (state is ImageFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Image upload error: ${state.error}')),
              );
              setState(() {
                _isUploading = false;
              });
            }
          },
        ),
        BlocListener<ElderBloc, ElderState>(
          listener: (context, state) {
            if (state is ElderSuccess) {
              setState(() {
                _elderId = state.elder.elder.elderId;
              });
            }
          },
        ),
        BlocListener<CaregiverBloc, CaregiverState>(
          listener: (context, state) {
            if (state is CaregiverSuccess) {
              setState(() {
                _caregiverId = state.caregiver.caregiver.caregiverId;
              });
            }
          },
        ),
      ],
      child: BlocBuilder<ElderBloc, ElderState>(
        builder: (context, elderState) {
          return BlocBuilder<CaregiverBloc, CaregiverState>(
            builder: (context, caregiverState) {
              final hasElderProfile = elderState is ElderSuccess;

              final hasCaregiverProfile = caregiverState is CaregiverSuccess;

              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Add top padding to center vertically when screen is large enough
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),

                        // Center the profile images
                        Center(
                          child: Column(
                            children: [
                              _buildProfileImage(
                                imageFile: _elderImage,
                                onTap: () => _pickImageFromGallery(true),
                                title: "Elder",
                                isAvailable: hasElderProfile,
                              ),
                              const SizedBox(height: 32),
                              _buildProfileImage(
                                imageFile: _caregiverImage,
                                onTap: () => _pickImageFromGallery(false),
                                title: "Caregiver",
                                isAvailable: hasCaregiverProfile,
                              ),
                            ],
                          ),
                        ),

                        // Add spacing before buttons
                        const SizedBox(height: 36),

                        // Remove the extra padding to match other screens
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MainButton(
                              buttonText: widget.isFinalStep
                                  ? "Selesai"
                                  : "Selanjutnya",
                              onTap: _isUploading
                                  ? () {}
                                  : () {
                                      if ((_elderImage != null &&
                                              hasElderProfile) ||
                                          (_caregiverImage != null &&
                                              hasCaregiverProfile)) {
                                        _savePhotos();
                                      } else {
                                        widget.onNext();
                                      }
                                    },
                              color: (_elderImage != null ||
                                      _caregiverImage != null ||
                                      !_isUploading)
                                  ? AppColors.primaryMain
                                  : AppColors.neutral30,
                            ),
                            const SizedBox(height: 12),
                            MainButton(
                              buttonText: "Lewati",
                              onTap: _isUploading ? () {} : widget.onSkip,
                              color: Colors.white,
                            ),
                          ],
                        ),

                        // Add some bottom padding
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  // Loading overlay
                  if (_isUploading ||
                      elderState is ElderLoading ||
                      caregiverState is CaregiverLoading ||
                      context.watch<ImageBloc>().state is ImageLoading)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
