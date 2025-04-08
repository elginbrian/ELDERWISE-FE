import 'dart:io';

import 'package:elderwise/domain/entities/caregiver.dart';
import 'package:elderwise/domain/entities/elder.dart';
import 'package:elderwise/domain/enums/entity_type.dart';
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

  // Data state variables
  bool _isLoading = true;
  bool _isSaving = false;
  String? _userId;
  String? _elderId;
  String? _caregiverId;
  dynamic _elderData;
  dynamic _caregiverData;
  String? _elderPhotoUrl;
  String? _caregiverPhotoUrl;
  bool _elderImageChanged = false;
  bool _caregiverImageChanged = false;

  // Track form changes to prevent unnecessary API calls
  bool _elderFormChanged = false;
  bool _caregiverFormChanged = false;

  // Controllers for text fields
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

    // Add change listeners to all controllers
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

    // Get current user using AuthBloc
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

    // Fetch elder and caregiver data in parallel
    if (_userId != null && _userId!.isNotEmpty) {
      context.read<UserBloc>().add(GetUserEldersEvent(_userId!));
      context.read<UserBloc>().add(GetUserCaregiversEvent(_userId!));
    }
  }

  void _populateElderData(dynamic elderData) {
    if (elderData == null || elderData.isEmpty) return;

    final elder = elderData[0];

    // Prevent UI flicker by checking if data is actually different
    final bool needsUpdate = _elderData == null ||
        _elderData['name'] != elder['name'] ||
        _elderData['gender'] != elder['gender'] ||
        _elderData['photo_url'] != elder['photo_url'];

    if (needsUpdate) {
      setState(() {
        _elderData = elder;
        _elderId = elder['elder_id'] ?? elder['id'] ?? '';

        // Only update controllers if form hasn't been modified by user
        if (!_elderFormChanged) {
          // Populate elder fields
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

    // Prevent UI flicker by checking if data is actually different
    final bool needsUpdate = _caregiverData == null ||
        _caregiverData['name'] != caregiver['name'] ||
        _caregiverData['gender'] != caregiver['gender'] ||
        (_caregiverData['profile_url'] != caregiver['profile_url'] &&
            _caregiverData['profileUrl'] != caregiver['profileUrl']);

    if (needsUpdate) {
      setState(() {
        _caregiverData = caregiver;
        _caregiverId = caregiver['caregiver_id'] ?? caregiver['id'] ?? '';

        // Only update controllers if form hasn't been modified by user
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
    // Show a subtle loading indicator while picking image
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

    // Dismiss the loading snackbar
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

    // Show optimistic UI update
    ToastHelper.showSuccessToast(context, 'Menyimpan perubahan...');

    // Parse birthdate from text field
    DateTime birthdate;
    try {
      final parts = _elderBirthdateController.text.split('/');
      if (parts.length == 3) {
        // Create the date as UTC and ensure it has timezone information
        birthdate = DateTime.utc(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
      } else {
        ToastHelper.showErrorToast(context, 'Format tanggal lahir tidak valid');
        return;
      }
    } catch (e) {
      ToastHelper.showErrorToast(context, 'Error parsing tanggal lahir: $e');
      return;
    }

    // Create Elder entity
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

    // Dispatch update event
    context.read<ElderBloc>().add(UpdateElderEvent(_elderId!, elder));

    // Reset form changed flag
    setState(() {
      _elderFormChanged = false;
    });

    // Upload image if changed - do this after profile update to ensure consistent behavior
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

    // Show optimistic UI update
    ToastHelper.showSuccessToast(context, 'Menyimpan perubahan...');

    // Parse birthdate from text field
    DateTime birthdate;
    try {
      final parts = _caregiverBirthdateController.text.split('/');
      if (parts.length == 3) {
        // Create the date as UTC and ensure it has timezone information
        birthdate = DateTime.utc(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
      } else {
        ToastHelper.showErrorToast(context, 'Format tanggal lahir tidak valid');
        return;
      }
    } catch (e) {
      ToastHelper.showErrorToast(context, 'Error parsing tanggal lahir: $e');
      return;
    }

    // Create Caregiver entity
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

    // Dispatch update event
    context
        .read<CaregiverBloc>()
        .add(UpdateCaregiverEvent(_caregiverId!, caregiver));

    // Reset form changed flag
    setState(() {
      _caregiverFormChanged = false;
    });

    // Upload image if changed - do this after profile update to ensure consistent behavior
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

  void _saveProfileChanges() {
    // Don't save if nothing changed
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
    });

    if (switchValue) {
      _updateElder();
    } else {
      _updateCaregiver();
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
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

  void _showConfirmationDialog(VoidCallback onConfirmed) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        onConfirmed: () {
          Navigator.of(context).pop();
          _saveProfileChanges();
        },
        onCancelled: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => EditProfileDialog(
        isElder: switchValue,
        elderNameController: _elderNameController,
        elderGenderController: _elderGenderController,
        elderBirthdateController: _elderBirthdateController,
        elderHeightController: _elderHeightController,
        elderWeightController: _elderWeightController,
        caregiverNameController: _caregiverNameController,
        caregiverGenderController: _caregiverGenderController,
        caregiverBirthdateController: _caregiverBirthdateController,
        caregiverPhoneController: _caregiverPhoneController,
        caregiverRelationshipController: _caregiverRelationshipController,
        onSave: () {
          Navigator.of(context).pop();
          _showConfirmationDialog(() {});
        },
        showConfirmationDialog: _showConfirmationDialog,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is CurrentUserSuccess) {
              // Extract user ID from CurrentUserSuccess state
              final userId = state.user.user.userId;
              _fetchUserData(userId);
            } else if (state is AuthFailure) {
              // Use a more user-friendly error message
              ToastHelper.showErrorToast(context,
                  ToastHelper.getUserFriendlyErrorMessage(state.error));
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserSuccess) {
              setState(() => _isLoading = false);

              // Check what type of response we received
              if (state.response.data != null && state.response.data is Map) {
                // Check if it's elder data
                if (state.response.data.containsKey('elders')) {
                  _populateElderData(state.response.data['elders']);
                }

                // Check if it's caregiver data
                if (state.response.data.containsKey('caregivers')) {
                  _populateCaregiverData(state.response.data['caregivers']);
                }
              }
            } else if (state is UserFailure) {
              setState(() => _isLoading = false);
              // Use a more user-friendly error message
              ToastHelper.showErrorToast(context,
                  ToastHelper.getUserFriendlyErrorMessage(state.error));
            }
          },
        ),
        // Add Elder bloc listener
        BlocListener<ElderBloc, ElderState>(
          listener: (context, state) {
            if (state is ElderLoading) {
              // Only show loading if not already showing (prevents flicker)
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

              // Refresh data
              if (_userId != null) {
                context.read<UserBloc>().add(GetUserEldersEvent(_userId!));
              }
            } else if (state is ElderFailure) {
              setState(() => _isSaving = false);
              // Use a more user-friendly error message
              ToastHelper.showErrorToast(context,
                  ToastHelper.getUserFriendlyErrorMessage(state.error));
            }
          },
        ),
        // Add Caregiver bloc listener
        BlocListener<CaregiverBloc, CaregiverState>(
          listener: (context, state) {
            if (state is CaregiverLoading) {
              // Only show loading if not already showing (prevents flicker)
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

              // Refresh data
              if (_userId != null) {
                context.read<UserBloc>().add(GetUserCaregiversEvent(_userId!));
              }
            } else if (state is CaregiverFailure) {
              setState(() => _isSaving = false);
              // Use a more user-friendly error message
              ToastHelper.showErrorToast(context,
                  ToastHelper.getUserFriendlyErrorMessage(state.error));
            }
          },
        ),
        // Add Image bloc listener
        BlocListener<ImageBloc, ImageState>(
          listener: (context, state) {
            if (state is ImageLoading) {
              // Only show loading if not already showing (prevents flicker)
              if (!_isSaving) {
                setState(() => _isSaving = true);
              }
            } else if (state is ImageUploadSuccess) {
              // Update photo URL based on entity type
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
              // Use a more user-friendly error message
              ToastHelper.showErrorToast(context,
                  ToastHelper.getUserFriendlyErrorMessage(state.error));
            }
          },
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'lib/presentation/screens/assets/images/bg_floral.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  AnimatedOpacity(
                    opacity: _isLoading ? 0.5 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: ProfileHeader(
                      isElder: switchValue,
                      elderImage: _elderImage,
                      caregiverImage: _caregiverImage,
                      elderPhotoUrl: _elderPhotoUrl,
                      caregiverPhotoUrl: _caregiverPhotoUrl,
                      elderData: _elderData,
                      caregiverData: _caregiverData,
                      onImagePick: _isLoading || _isSaving
                          ? (_) {}
                          : _pickImageFromGallery,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: _buildProfileContent(),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 24,
              left: 0,
              child: FloatingActionButton(
                onPressed: _isSaving
                    ? null
                    : () => Navigator.pop(context), // Disable during saving
                backgroundColor: Colors.transparent,
                elevation: 0,
                hoverElevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                splashColor: Colors.transparent,
                child: const Icon(Icons.keyboard_arrow_left,
                    color: AppColors.neutral10, size: 36),
              ),
            ),
            // Show a subtle overlay when loading or saving
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
    );
  }

  Widget _buildProfileContent() {
    return Container(
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.neutral20,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
      ),
      child: Column(
        children: [
          ProfileToggle(
            value: switchValue,
            onChanged: _isLoading || _isSaving
                ? (_) {} // Disable toggle while loading/saving
                : (value) => setState(() {
                      switchValue = value;
                    }),
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
                      )
                    : CaregiverProfileView(
                        key: const ValueKey('caregiver_profile'),
                        nameController: _caregiverNameController,
                        genderController: _caregiverGenderController,
                        birthdateController: _caregiverBirthdateController,
                        phoneController: _caregiverPhoneController,
                        relationshipController:
                            _caregiverRelationshipController,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedOpacity(
            opacity: _isLoading || _isSaving ? 0.5 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: GestureDetector(
              onTap: _isLoading || _isSaving ? null : _showEditDialog,
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
            ),
          )
        ],
      ),
    );
  }
}
