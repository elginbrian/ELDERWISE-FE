import 'dart:io';

import 'package:elderwise/domain/entities/caregiver.dart';
import 'package:elderwise/domain/entities/elder.dart';
import 'package:elderwise/domain/enums/entity_type.dart';
import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:elderwise/presentation/bloc/auth/auth_bloc.dart';
import 'package:elderwise/presentation/bloc/auth/auth_event.dart';
import 'package:elderwise/presentation/bloc/auth/auth_state.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_bloc.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_event.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_state.dart';
import 'package:elderwise/presentation/bloc/elder/elder_bloc.dart';
import 'package:elderwise/presentation/bloc/elder/elder_event.dart';
import 'package:elderwise/presentation/bloc/elder/elder_state.dart';
import 'package:elderwise/presentation/bloc/image/image_bloc.dart';
import 'package:elderwise/presentation/bloc/image/image_event.dart';
import 'package:elderwise/presentation/bloc/image/image_state.dart';
import 'package:elderwise/presentation/bloc/user/user_bloc.dart';
import 'package:elderwise/presentation/bloc/user/user_event.dart';
import 'package:elderwise/presentation/bloc/user/user_state.dart';
import 'package:elderwise/presentation/bloc/user_mode/user_mode_bloc.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/utils/toast_helper.dart';
import 'package:elderwise/presentation/widgets/profile_screen/caregiver_profile_view.dart';
import 'package:elderwise/presentation/widgets/profile_screen/elder_profile_view.dart';
import 'package:elderwise/presentation/widgets/profile_screen/image_picker_dialog.dart';
import 'package:elderwise/presentation/widgets/profile_screen/profile_dialogs.dart';
import 'package:elderwise/presentation/widgets/profile_screen/profile_header.dart';
import 'package:elderwise/presentation/widgets/profile_screen/profile_toggle.dart';
import 'package:elderwise/presentation/widgets/profile_screen/upload_options_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool switchValue = false;
  File? _elderImage;
  File? _caregiverImage;

  bool _isLoading = true;
  bool _isSaving = false;
  bool _editMode = false; // Add this line to track edit mode
  String? _userId;
  String? _elderId;
  String? _caregiverId;
  dynamic _elderData;
  dynamic _caregiverData;
  String? _elderPhotoUrl;
  String? _caregiverPhotoUrl;
  bool _elderImageChanged = false;
  bool _caregiverImageChanged = false;

  bool _elderFormChanged = false;
  bool _caregiverFormChanged = false;

  final TextEditingController _elderNameController = TextEditingController();
  final TextEditingController _elderGenderController = TextEditingController();
  final TextEditingController _elderBirthdateController =
      TextEditingController();
  final TextEditingController _elderHeightController = TextEditingController();
  final TextEditingController _elderWeightController = TextEditingController();

  final TextEditingController _caregiverNameController =
      TextEditingController();
  final TextEditingController _caregiverGenderController =
      TextEditingController();
  final TextEditingController _caregiverBirthdateController =
      TextEditingController();
  final TextEditingController _caregiverPhoneController =
      TextEditingController();
  final TextEditingController _caregiverRelationshipController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _elderNameController.addListener(_onElderFormChanged);
    _elderGenderController.addListener(_onElderFormChanged);
    _elderBirthdateController.addListener(_onElderFormChanged);
    _elderHeightController.addListener(_onElderFormChanged);
    _elderWeightController.addListener(_onElderFormChanged);

    _caregiverNameController.addListener(_onCaregiverFormChanged);
    _caregiverGenderController.addListener(_onCaregiverFormChanged);
    _caregiverBirthdateController.addListener(_onCaregiverFormChanged);
    _caregiverPhoneController.addListener(_onCaregiverFormChanged);
    _caregiverRelationshipController.addListener(_onCaregiverFormChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(GetCurrentUserEvent());
    });
  }

  void _onElderFormChanged() {
    setState(() {
      _elderFormChanged = true;
    });
  }

  void _onCaregiverFormChanged() {
    setState(() {
      _caregiverFormChanged = true;
    });
  }

  void _fetchUserData(String userId) {
    setState(() {
      _userId = userId;
    });

    if (_userId != null && _userId!.isNotEmpty) {
      context.read<UserBloc>().add(GetUserEldersEvent(_userId!));
      context.read<UserBloc>().add(GetUserCaregiversEvent(_userId!));
    }
  }

  void _populateElderData(dynamic elderData) {
    if (elderData == null || elderData.isEmpty) return;

    final elder = elderData[0];

    final bool needsUpdate = _elderData == null ||
        _elderData['name'] != elder['name'] ||
        _elderData['gender'] != elder['gender'] ||
        _elderData['photo_url'] != elder['photo_url'];

    if (needsUpdate) {
      setState(() {
        _elderData = elder;
        _elderId = elder['elder_id'] ?? elder['id'] ?? '';

        if (!_elderFormChanged) {
          _elderNameController.text = elder['name'] ?? '';
          _elderGenderController.text = elder['gender'] ?? '';

          if (elder['birthdate'] != null) {
            try {
              final birthdate = DateTime.parse(elder['birthdate']);
              _elderBirthdateController.text =
                  "${birthdate.day}/${birthdate.month}/${birthdate.year}";
            } catch (e) {
              debugPrint('Error parsing birthdate: $e');
            }
          }

          final bodyHeight = elder['body_height'] ?? elder['bodyHeight'];
          if (bodyHeight != null) {
            try {
              final double height = bodyHeight is num
                  ? bodyHeight.toDouble()
                  : double.parse(bodyHeight.toString());
              _elderHeightController.text = height.round().toString();
            } catch (e) {
              debugPrint('Error parsing body height: $e');
            }
          }

          final bodyWeight = elder['body_weight'] ?? elder['bodyWeight'];
          if (bodyWeight != null) {
            try {
              final double weight = bodyWeight is num
                  ? bodyWeight.toDouble()
                  : double.parse(bodyWeight.toString());
              _elderWeightController.text = weight.round().toString();
            } catch (e) {
              debugPrint('Error parsing body weight: $e');
            }
          }
        }

        if (elder['photo_url'] != null) {
          _elderPhotoUrl = elder['photo_url'];
        }
      });
    }
  }

  void _populateCaregiverData(dynamic caregiverData) {
    if (caregiverData == null || caregiverData.isEmpty) return;

    final caregiver = caregiverData[0];

    final bool needsUpdate = _caregiverData == null ||
        _caregiverData['name'] != caregiver['name'] ||
        _caregiverData['gender'] != caregiver['gender'] ||
        (_caregiverData['profile_url'] != caregiver['profile_url'] &&
            _caregiverData['profileUrl'] != caregiver['profileUrl']);

    if (needsUpdate) {
      setState(() {
        _caregiverData = caregiver;
        _caregiverId = caregiver['caregiver_id'] ?? caregiver['id'] ?? '';

        if (!_caregiverFormChanged) {
          _caregiverNameController.text = caregiver['name'] ?? '';
          _caregiverGenderController.text = caregiver['gender'] ?? '';

          if (caregiver['birthdate'] != null) {
            try {
              final birthdate = DateTime.parse(caregiver['birthdate']);
              _caregiverBirthdateController.text =
                  "${birthdate.day}/${birthdate.month}/${birthdate.year}";
            } catch (e) {
              debugPrint('Error parsing birthdate: $e');
            }
          }

          final phoneNumber =
              caregiver['phone_number'] ?? caregiver['phoneNumber'];
          if (phoneNumber != null) {
            _caregiverPhoneController.text = phoneNumber.toString();
          }

          _caregiverRelationshipController.text =
              caregiver['relationship'] ?? '';
        }

        if (caregiver['profile_url'] != null) {
          _caregiverPhotoUrl = caregiver['profile_url'];
        } else if (caregiver['profileUrl'] != null) {
          _caregiverPhotoUrl = caregiver['profileUrl'];
        }
      });
    }
  }

  Future<void> _pickImageFromGallery(bool isElder) async {
    final loadingSnackBar = SnackBar(
      content: Row(
        children: const [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10),
          Text('Mempersiapkan galeri...'),
        ],
      ),
      duration: const Duration(milliseconds: 800),
      backgroundColor: Colors.black54,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(loadingSnackBar);

    final selectedImage =
        await ProfileImagePicker.pickImageFromGallery(context);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (selectedImage != null) {
      final confirmed = await ProfileImagePicker.showImageConfirmationDialog(
          context, selectedImage, isElder);

      if (confirmed) {
        setState(() {
          if (isElder) {
            _elderImage = selectedImage;
            _elderImageChanged = true;
          } else {
            _caregiverImage = selectedImage;
            _caregiverImageChanged = true;
          }
        });
        _showUploadOptionsDialog(isElder);
      }
    }
  }

  void _showUploadOptionsDialog(bool isElder) {
    final entityId = isElder ? _elderId : _caregiverId;

    if (entityId == null || entityId.isEmpty) {
      ToastHelper.showErrorToast(
          context, '${isElder ? 'Elder' : 'Caregiver'} ID tidak ditemukan');
      return;
    }

    UploadOptionsDialog.show(context, isElder ? 'Elder' : 'Caregiver')
        .then((option) {
      if (option == UploadOption.now) {
        _uploadImageNow(isElder);
      }
    });
  }

  void _uploadImageNow(bool isElder) {
    setState(() {
      _isSaving = true;
    });

    if (isElder && _elderImage != null && _elderId != null) {
      _uploadProfileImage(
        file: _elderImage!,
        entityId: _elderId!,
        entityType: EntityType.elder,
      );
    } else if (!isElder && _caregiverImage != null && _caregiverId != null) {
      _uploadProfileImage(
        file: _caregiverImage!,
        entityId: _caregiverId!,
        entityType: EntityType.caregiver,
      );
    } else {
      setState(() {
        _isSaving = false;
      });
      ToastHelper.showErrorToast(context, 'Tidak dapat mengunggah foto profil');
    }
  }

  void _updateElder() {
    if (_elderId == null || _elderId!.isEmpty) {
      ToastHelper.showErrorToast(context, 'Elder ID tidak ditemukan');
      return;
    }

    ToastHelper.showSuccessToast(context, 'Menyimpan perubahan...');

    DateTime birthdate;
    try {
      final parts = _elderBirthdateController.text.split('/');
      if (parts.length == 3) {
        birthdate = DateTime.utc(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } else {
        ToastHelper.showErrorToast(context, 'Format tanggal lahir tidak valid');
        return;
      }
    } catch (e) {
      ToastHelper.showErrorToast(context, 'Error parsing tanggal lahir: $e');
      return;
    }

    final elder = Elder(
      elderId: _elderId!,
      userId: _userId!,
      name: _elderNameController.text,
      gender: _elderGenderController.text,
      birthdate: birthdate,
      bodyHeight: double.tryParse(_elderHeightController.text) ?? 0,
      bodyWeight: double.tryParse(_elderWeightController.text) ?? 0,
      photoUrl: _elderPhotoUrl ?? '',
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    context.read<ElderBloc>().add(UpdateElderEvent(_elderId!, elder));

    setState(() {
      _elderFormChanged = false;
    });

    if (_elderImageChanged && _elderImage != null) {
      _uploadProfileImage(
        file: _elderImage!,
        entityId: _elderId!,
        entityType: EntityType.elder,
      );
    }
  }

  void _updateCaregiver() {
    if (_caregiverId == null || _caregiverId!.isEmpty) {
      ToastHelper.showErrorToast(context, 'Caregiver ID tidak ditemukan');
      return;
    }

    ToastHelper.showSuccessToast(context, 'Menyimpan perubahan...');

    DateTime birthdate;
    try {
      final parts = _caregiverBirthdateController.text.split('/');
      if (parts.length == 3) {
        birthdate = DateTime.utc(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } else {
        ToastHelper.showErrorToast(context, 'Format tanggal lahir tidak valid');
        return;
      }
    } catch (e) {
      ToastHelper.showErrorToast(context, 'Error parsing tanggal lahir: $e');
      return;
    }

    final caregiver = Caregiver(
      caregiverId: _caregiverId!,
      userId: _userId!,
      name: _caregiverNameController.text,
      gender: _caregiverGenderController.text,
      birthdate: birthdate,
      phoneNumber: _caregiverPhoneController.text,
      profileUrl: _caregiverPhotoUrl ?? '',
      relationship: _caregiverRelationshipController.text,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    context
        .read<CaregiverBloc>()
        .add(UpdateCaregiverEvent(_caregiverId!, caregiver));

    setState(() {
      _caregiverFormChanged = false;
    });

    if (_caregiverImageChanged && _caregiverImage != null) {
      _uploadProfileImage(
        file: _caregiverImage!,
        entityId: _caregiverId!,
        entityType: EntityType.caregiver,
      );
    }
  }

  void _uploadProfileImage({
    required File file,
    required String entityId,
    required EntityType entityType,
  }) {
    final fileName =
        '${_userId}_${entityType.toStringValue()}_${path.basename(file.path)}';

    context.read<ImageBloc>().add(UploadImageEvent(
          file: file,
          fileName: fileName,
          userId: _userId!,
          entityId: entityId,
          entityType: entityType,
        ));
  }

  void _saveChanges() {
    if (!_elderFormChanged &&
        !_caregiverFormChanged &&
        !_elderImageChanged &&
        !_caregiverImageChanged) {
      ToastHelper.showSuccessToast(
          context, 'Tidak ada perubahan untuk disimpan');
      return;
    }

    setState(() {
      _isSaving = true;
      _editMode = false; // Exit edit mode after saving
    });

    if (switchValue) {
      _updateElder();
    } else {
      _updateCaregiver();
    }
  }

  void _toggleEditMode() {
    setState(() {
      _editMode = !_editMode;
    });
  }

  @override
  void dispose() {
    _elderNameController.removeListener(_onElderFormChanged);
    _elderGenderController.removeListener(_onElderFormChanged);
    _elderBirthdateController.removeListener(_onElderFormChanged);
    _elderHeightController.removeListener(_onElderFormChanged);
    _elderWeightController.removeListener(_onElderFormChanged);

    _caregiverNameController.removeListener(_onCaregiverFormChanged);
    _caregiverGenderController.removeListener(_onCaregiverFormChanged);
    _caregiverBirthdateController.removeListener(_onCaregiverFormChanged);
    _caregiverPhoneController.removeListener(_onCaregiverFormChanged);
    _caregiverRelationshipController.removeListener(_onCaregiverFormChanged);

    _elderNameController.dispose();
    _elderGenderController.dispose();
    _elderBirthdateController.dispose();
    _elderHeightController.dispose();
    _elderWeightController.dispose();

    _caregiverNameController.dispose();
    _caregiverGenderController.dispose();
    _caregiverBirthdateController.dispose();
    _caregiverPhoneController.dispose();
    _caregiverRelationshipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModeState = context.watch<UserModeBloc>().state;
    final isElderMode = userModeState.userMode == UserMode.elder;
    final isCaregiverMode = userModeState.userMode == UserMode.caregiver;

    // Disable edit mode in Elder Mode
    if (isElderMode && _editMode) {
      setState(() {
        _editMode = false;
      });
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is CurrentUserSuccess) {
              final userId = state.user.user.userId;
              _fetchUserData(userId);
            } else if (state is AuthFailure) {
              ToastHelper.showErrorToast(context,
                  ToastHelper.getUserFriendlyErrorMessage(state.error));
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserSuccess) {
              setState(() => _isLoading = false);

              if (state.response.data != null && state.response.data is Map) {
                if (state.response.data.containsKey('elders')) {
                  _populateElderData(state.response.data['elders']);
                }

                if (state.response.data.containsKey('caregivers')) {
                  _populateCaregiverData(state.response.data['caregivers']);
                }
              }
            } else if (state is UserFailure) {
              setState(() => _isLoading = false);
              ToastHelper.showErrorToast(context,
                  ToastHelper.getUserFriendlyErrorMessage(state.error));
            }
          },
        ),
        BlocListener<ElderBloc, ElderState>(
          listener: (context, state) {
            if (state is ElderLoading) {
              if (!_isSaving) {
                setState(() => _isSaving = true);
              }
            } else if (state is ElderSuccess) {
              setState(() {
                _isSaving = false;
                _elderImageChanged = false;
              });
              ToastHelper.showSuccessToast(
                  context, 'Profil elder berhasil diperbarui');

              if (_userId != null) {
                context.read<UserBloc>().add(GetUserEldersEvent(_userId!));
              }
            } else if (state is ElderFailure) {
              setState(() => _isSaving = false);
              ToastHelper.showErrorToast(context,
                  ToastHelper.getUserFriendlyErrorMessage(state.error));
            }
          },
        ),
        BlocListener<CaregiverBloc, CaregiverState>(
          listener: (context, state) {
            if (state is CaregiverLoading) {
              if (!_isSaving) {
                setState(() => _isSaving = true);
              }
            } else if (state is CaregiverSuccess) {
              setState(() {
                _isSaving = false;
                _caregiverImageChanged = false;
              });
              ToastHelper.showSuccessToast(
                  context, 'Profil caregiver berhasil diperbarui');

              if (_userId != null) {
                context.read<UserBloc>().add(GetUserCaregiversEvent(_userId!));
              }
            } else if (state is CaregiverFailure) {
              setState(() => _isSaving = false);
              ToastHelper.showErrorToast(context,
                  ToastHelper.getUserFriendlyErrorMessage(state.error));
            }
          },
        ),
        BlocListener<ImageBloc, ImageState>(
          listener: (context, state) {
            if (state is ImageLoading) {
              if (!_isSaving) {
                setState(() => _isSaving = true);
              }
            } else if (state is ImageUploadSuccess) {
              if (state.uploadedImage.entityType == EntityType.elder) {
                setState(() {
                  _elderPhotoUrl = state.uploadedImage.url;
                  _elderImageChanged = false;
                  _isSaving = false;
                });
              } else if (state.uploadedImage.entityType ==
                  EntityType.caregiver) {
                setState(() {
                  _caregiverPhotoUrl = state.uploadedImage.url;
                  _caregiverImageChanged = false;
                  _isSaving = false;
                });
              }
              ToastHelper.showSuccessToast(
                  context, 'Foto profil berhasil diperbarui');
            } else if (state is ImageFailure) {
              setState(() => _isSaving = false);
              ToastHelper.showErrorToast(context,
                  ToastHelper.getUserFriendlyErrorMessage(state.error));
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.primaryMain,
        floatingActionButton: isCaregiverMode
            ? null
            : FloatingActionButton(
                onPressed: _toggleEditMode,
                backgroundColor:
                    _editMode ? AppColors.primaryMain : AppColors.primaryMain,
                child: Icon(_editMode ? Icons.close : Icons.edit),
              ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _isLoading || _isSaving
                              ? null
                              : () => _pickImageFromGallery(switchValue),
                          child: Stack(
                            children: [
                              Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  color: AppColors.secondarySurface,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: switchValue
                                    ? ClipOval(
                                        child: _elderImage != null
                                            ? Image.file(
                                                _elderImage!,
                                                fit: BoxFit.cover,
                                              )
                                            : _elderPhotoUrl != null &&
                                                    _elderPhotoUrl!.isNotEmpty
                                                ? Image.network(
                                                    _elderPhotoUrl!,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        const Icon(Icons.person,
                                                            size: 40,
                                                            color: AppColors
                                                                .neutral60),
                                                  )
                                                : const Icon(Icons.person,
                                                    size: 40,
                                                    color: AppColors.neutral60),
                                      )
                                    : ClipOval(
                                        child: _caregiverImage != null
                                            ? Image.file(
                                                _caregiverImage!,
                                                fit: BoxFit.cover,
                                              )
                                            : _caregiverPhotoUrl != null &&
                                                    _caregiverPhotoUrl!
                                                        .isNotEmpty
                                                ? Image.network(
                                                    _caregiverPhotoUrl!,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        const Icon(Icons.person,
                                                            size: 40,
                                                            color: AppColors
                                                                .neutral60),
                                                  )
                                                : const Icon(Icons.person,
                                                    size: 40,
                                                    color: AppColors.neutral60),
                                      ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppColors.neutral40,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.secondarySurface,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 14,
                                    color: AppColors.secondarySurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                switchValue
                                    ? (_elderData != null
                                        ? _elderData['name'] ?? 'Elder'
                                        : 'Elder')
                                    : (_caregiverData != null
                                        ? _caregiverData['name'] ?? 'Caregiver'
                                        : 'Caregiver'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: AppColors.neutral90,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                switchValue ? 'Elder' : 'Caregiver',
                                style: const TextStyle(
                                  fontSize: 14, // Reduced from 16
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  color: AppColors.neutral80,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: AnimatedOpacity(
                      opacity: _isLoading ? 0.5 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: AppColors.secondarySurface,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32.0),
                            topRight: Radius.circular(32.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 32),
                            Expanded(
                              child: _buildProfileContent(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_isLoading || _isSaving)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryMain),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _isSaving
                                  ? 'Menyimpan perubahan...'
                                  : 'Memuat data...',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          32, 0, 32, 32), // Further reduced top padding from 16 to 0
      width: double.infinity,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.neutral40,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: ProfileToggle(
              value: switchValue,
              onChanged: (_isLoading ||
                      _isSaving ||
                      _editMode) // Disable toggle when editing
                  ? (_) {}
                  : (value) => setState(() {
                        switchValue = value;
                      }),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: switchValue
                    ? ElderProfileView(
                        key: const ValueKey('elder_profile'),
                        nameController: _elderNameController,
                        genderController: _elderGenderController,
                        birthdateController: _elderBirthdateController,
                        heightController: _elderHeightController,
                        weightController: _elderWeightController,
                        readOnly: !_editMode, // Pass edit mode to view
                      )
                    : CaregiverProfileView(
                        key: const ValueKey('caregiver_profile'),
                        nameController: _caregiverNameController,
                        genderController: _caregiverGenderController,
                        birthdateController: _caregiverBirthdateController,
                        phoneController: _caregiverPhoneController,
                        relationshipController:
                            _caregiverRelationshipController,
                        readOnly: !_editMode, // Pass edit mode to view
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedOpacity(
            opacity: _isLoading || _isSaving ? 0.5 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: _buildEditButtons(),
          )
        ],
      ),
    );
  }

  Widget _buildEditButtons() {
    final userModeState = context.watch<UserModeBloc>().state;
    final isElderMode = userModeState.userMode == UserMode.elder;

    if (isElderMode) {
      return const SizedBox.shrink(); // Hide edit buttons in Elder Mode
    }

    return _editMode
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryMain,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Simpan Perubahan",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: AppColors
                          .neutral100, // Changed from Colors.white to Colors.black
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _toggleEditMode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: const BorderSide(color: AppColors.neutral40),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                child: const Text(
                  "Batal",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: AppColors.neutral90,
                  ),
                ),
              ),
            ],
          )
        : GestureDetector(
            onTap: (_isLoading || _isSaving) ? null : _toggleEditMode,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: AppColors.neutral90,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.edit, size: 16),
                ),
              ],
            ),
          );
  }
}
