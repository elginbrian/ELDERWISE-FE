import 'dart:io';
import 'package:elderwise/domain/enums/entity_type.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_bloc.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_state.dart';
import 'package:elderwise/presentation/bloc/elder/elder_bloc.dart';
import 'package:elderwise/presentation/bloc/elder/elder_state.dart';
import 'package:elderwise/presentation/bloc/image/image_bloc.dart';
import 'package:elderwise/presentation/bloc/image/image_event.dart';
import 'package:elderwise/presentation/bloc/image/image_state.dart';
import 'package:elderwise/presentation/bloc/user/user_bloc.dart';
import 'package:elderwise/presentation/bloc/user/user_event.dart';
import 'package:elderwise/presentation/bloc/user/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:path/path.dart' as path;
import 'package:elderwise/presentation/utils/toast_helper.dart';

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
  bool _needElderUpload = false;
  bool _needCaregiverUpload = false;
  String? _elderPhotoUrl;
  String? _caregiverPhotoUrl;

  bool _isCheckingElderUser = true;
  bool _isCheckingCaregiverUser = true;
  bool _hasElderProfile = false;
  bool _hasCaregiverProfile = false;

  @override
  void initState() {
    super.initState();
    assert(widget.userId.isNotEmpty, 'User ID must be provided');

    final elderState = context.read<ElderBloc>().state;
    final caregiverState = context.read<CaregiverBloc>().state;

    if (elderState is ElderSuccess) {
      _elderId = elderState.elder.elder.elderId;
      _elderPhotoUrl = elderState.elder.elder.photoUrl;
      _hasElderProfile = true;
    }

    if (caregiverState is CaregiverSuccess) {
      _caregiverId = caregiverState.caregiver.caregiver.caregiverId;
      _caregiverPhotoUrl = caregiverState.caregiver.caregiver.profileUrl;
      _hasCaregiverProfile = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserBloc>().add(GetUserEldersEvent(widget.userId));
      context.read<UserBloc>().add(GetUserCaregiversEvent(widget.userId));
    });
  }

  void _populateElderData(dynamic elderData) {
    if (elderData == null || elderData.isEmpty) return;

    final elder = elderData[0];

    setState(() {
      _hasElderProfile = true;
      _elderId = elder['elder_id'] ?? elder['id'] ?? '';

      if (elder['photo_url'] != null) {
        _elderPhotoUrl = elder['photo_url'];
      }
    });
  }

  void _populateCaregiverData(dynamic caregiverData) {
    if (caregiverData == null || caregiverData.isEmpty) return;

    final caregiver = caregiverData[0];

    setState(() {
      _hasCaregiverProfile = true;
      _caregiverId = caregiver['caregiver_id'] ?? caregiver['id'] ?? '';

      if (caregiver['profile_url'] != null) {
        _caregiverPhotoUrl = caregiver['profile_url'];
      } else if (caregiver['profileUrl'] != null) {
        _caregiverPhotoUrl = caregiver['profileUrl'];
      }
    });
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
      _needElderUpload = false;
      _needCaregiverUpload = false;
    });

    bool needsUpload = false;

    if (_elderImage != null && _elderId != null) {
      needsUpload = true;
      setState(() {
        _needElderUpload = true;
      });
      _uploadElderPhoto();
    } else {
      setState(() {
        _elderPhotoUploaded = true;
      });
    }

    if (_caregiverImage != null && _caregiverId != null) {
      needsUpload = true;
      setState(() {
        _needCaregiverUpload = true;
      });
      _uploadCaregiverPhoto();
    } else {
      setState(() {
        _caregiverPhotoUploaded = true;
      });
    }

    if (!needsUpload) {
      _completeProcess();
    } else {
      Future.delayed(const Duration(seconds: 30), () {
        if (mounted && _isUploading) {
          setState(() {
            _isUploading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Upload timed out. Please try again.',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: AppColors.primaryMain,
            ),
          );
        }
      });
    }
  }

  void _uploadElderPhoto() {
    if (_elderId == null || _elderId!.isEmpty) {
      debugPrint('Elder ID is missing. Cannot upload photo.');
      setState(() {
        _elderPhotoUploaded = true;
        _checkCompletionStatus();
      });
      return;
    }

    final fileName =
        '${widget.userId}_elder_${path.basename(_elderImage!.path)}';
    final entityType = EntityType.elder;

    debugPrint(
        'Uploading elder photo with EntityType: ${entityType.toStringValue()}');
    debugPrint('Elder ID: $_elderId');

    context.read<ImageBloc>().add(UploadImageEvent(
          file: _elderImage!,
          fileName: fileName,
          userId: widget.userId,
          entityId: _elderId!,
          entityType: entityType,
        ));
  }

  void _uploadCaregiverPhoto() {
    if (_caregiverId == null || _caregiverId!.isEmpty) {
      debugPrint('Caregiver ID is missing. Cannot upload photo.');
      setState(() {
        _caregiverPhotoUploaded = true;
        _checkCompletionStatus();
      });
      return;
    }

    final fileName =
        '${widget.userId}_caregiver_${path.basename(_caregiverImage!.path)}';
    final entityType = EntityType.caregiver;

    debugPrint(
        'Uploading caregiver photo with EntityType: ${entityType.toStringValue()}');
    debugPrint('Caregiver ID: $_caregiverId');

    context.read<ImageBloc>().add(UploadImageEvent(
          file: _caregiverImage!,
          fileName: fileName,
          userId: widget.userId,
          entityId: _caregiverId!,
          entityType: entityType,
        ));
  }

  void _checkCompletionStatus() {
    bool isComplete = true;

    if (_needElderUpload && !_elderPhotoUploaded) {
      isComplete = false;
    }

    if (_needCaregiverUpload && !_caregiverPhotoUploaded) {
      isComplete = false;
    }

    if (isComplete) {
      _completeProcess();
    }
  }

  void _completeProcess() {
    if (mounted) {
      setState(() {
        _isUploading = false;
      });
      widget.onNext();
    }
  }

  Widget _buildProfileImage({
    required File? imageFile,
    required VoidCallback onTap,
    required String title,
    required bool isAvailable,
    String? photoUrl,
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
                    : imageFile != null || photoUrl != null
                        ? AppColors.primaryMain
                        : AppColors.neutral70,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(75),
              child: imageFile != null
                  ? Image.file(imageFile, fit: BoxFit.cover)
                  : photoUrl != null && photoUrl.isNotEmpty
                      ? Image.network(
                          photoUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                if (isAvailable)
                                  const Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                    color: AppColors.neutral80,
                                  )
                                else
                                  Image.asset("${iconImages}plus.png",
                                      color: AppColors.neutral30),
                                Positioned(
                                  bottom: 30,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      "Error loading image",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                        color: isAvailable
                                            ? AppColors.neutral80
                                            : AppColors.neutral30,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            if (isAvailable)
                              const Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: AppColors.neutral80,
                              )
                            else
                              Image.asset("${iconImages}plus.png",
                                  color: AppColors.neutral30),
                            Positioned(
                              bottom: 30,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
              if (state.uploadedImage.entityType == EntityType.elder) {
                setState(() {
                  _elderPhotoUploaded = true;
                });
              } else if (state.uploadedImage.entityType ==
                  EntityType.caregiver) {
                setState(() {
                  _caregiverPhotoUploaded = true;
                });
              }

              _checkCompletionStatus();
            } else if (state is ImageFailure) {
              debugPrint('Image Upload Error: ${state.error}');

              setState(() {
                _isUploading = false;

                if (_needElderUpload && !_elderPhotoUploaded) {
                  _elderPhotoUploaded = true;
                }
                if (_needCaregiverUpload && !_caregiverPhotoUploaded) {
                  _caregiverPhotoUploaded = true;
                }
              });
            }
          },
        ),
        BlocListener<ElderBloc, ElderState>(
          listener: (context, state) {
            if (state is ElderSuccess) {
              setState(() {
                _elderId = state.elder.elder.elderId;
                _elderPhotoUrl = state.elder.elder.photoUrl;
                _hasElderProfile = true;
              });
            }
          },
        ),
        BlocListener<CaregiverBloc, CaregiverState>(
          listener: (context, state) {
            if (state is CaregiverSuccess) {
              setState(() {
                _caregiverId = state.caregiver.caregiver.caregiverId;
                _caregiverPhotoUrl = state.caregiver.caregiver.profileUrl;
                _hasCaregiverProfile = true;
              });
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserSuccess) {
              if (state.response.data != null && state.response.data is Map) {
                if (state.response.data.containsKey('elders')) {
                  setState(() => _isCheckingElderUser = false);
                  _populateElderData(state.response.data['elders']);
                }

                if (state.response.data.containsKey('caregivers')) {
                  setState(() => _isCheckingCaregiverUser = false);
                  _populateCaregiverData(state.response.data['caregivers']);
                }
              }
            } else if (state is UserFailure) {
              setState(() {
                _isCheckingElderUser = false;
                _isCheckingCaregiverUser = false;
              });
              debugPrint('Failed to fetch profile data: ${state.error}');
            }
          },
        ),
      ],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          final isUserLoading = userState is UserLoading;
          final isLoading = _isUploading ||
              isUserLoading ||
              _isCheckingElderUser ||
              _isCheckingCaregiverUser ||
              context.watch<ImageBloc>().state is ImageLoading;

          if ((isUserLoading ||
                  _isCheckingElderUser ||
                  _isCheckingCaregiverUser) &&
              !_hasElderProfile &&
              !_hasCaregiverProfile) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Center(
                  child: Column(
                    children: [
                      _buildProfileImage(
                        imageFile: _elderImage,
                        onTap: () => _pickImageFromGallery(true),
                        title: "Elder",
                        isAvailable: _hasElderProfile,
                        photoUrl: _elderPhotoUrl,
                      ),
                      const SizedBox(height: 32),
                      _buildProfileImage(
                        imageFile: _caregiverImage,
                        onTap: () => _pickImageFromGallery(false),
                        title: "Caregiver",
                        isAvailable: _hasCaregiverProfile,
                        photoUrl: _caregiverPhotoUrl,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MainButton(
                      buttonText:
                          widget.isFinalStep ? "Selesai" : "Selanjutnya",
                      onTap: isLoading
                          ? () {}
                          : () {
                              if ((_elderImage != null && _hasElderProfile) ||
                                  (_caregiverImage != null &&
                                      _hasCaregiverProfile)) {
                                _savePhotos();
                              } else {
                                widget.onNext();
                              }
                            },
                      color: (_elderImage != null ||
                              _caregiverImage != null ||
                              !isLoading)
                          ? AppColors.primaryMain
                          : AppColors.neutral30,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 12),
                    MainButton(
                      buttonText: "Lewati",
                      onTap: isLoading ? () {} : widget.onSkip,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
