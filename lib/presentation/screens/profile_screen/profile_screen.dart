import 'dart:io';

import 'package:elderwise/presentation/bloc/auth/auth_bloc.dart';
import 'package:elderwise/presentation/bloc/auth/auth_event.dart';
import 'package:elderwise/presentation/bloc/auth/auth_state.dart';
import 'package:elderwise/presentation/bloc/user/user_bloc.dart';
import 'package:elderwise/presentation/bloc/user/user_event.dart';
import 'package:elderwise/presentation/bloc/user/user_state.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/profile_screen/caregiver_profile_view.dart';
import 'package:elderwise/presentation/widgets/profile_screen/elder_profile_view.dart';
import 'package:elderwise/presentation/widgets/profile_screen/profile_dialogs.dart';
import 'package:elderwise/presentation/widgets/profile_screen/profile_header.dart';
import 'package:elderwise/presentation/widgets/profile_screen/profile_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
  String? _userId;
  dynamic _elderData;
  dynamic _caregiverData;
  String? _elderPhotoUrl;
  String? _caregiverPhotoUrl;

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

    // Get current user using AuthBloc instead of UserBloc
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(GetCurrentUserEvent());
    });
  }

  void _fetchUserData(String userId) {
    setState(() {
      _userId = userId;
    });

    // Fetch elder and caregiver data
    if (_userId != null && _userId!.isNotEmpty) {
      context.read<UserBloc>().add(GetUserEldersEvent(_userId!));
      context.read<UserBloc>().add(GetUserCaregiversEvent(_userId!));
    }
  }

  void _populateElderData(dynamic elderData) {
    if (elderData == null || elderData.isEmpty) return;

    final elder = elderData[0];
    setState(() {
      _elderData = elder;

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

      // Handle body height with fallbacks
      final bodyHeight = elder['body_height'] ?? elder['bodyHeight'];
      if (bodyHeight != null) {
        try {
          final double height = bodyHeight is num
              ? (bodyHeight as num).toDouble()
              : double.parse(bodyHeight.toString());
          _elderHeightController.text = height.round().toString();
        } catch (e) {
          debugPrint('Error parsing body height: $e');
        }
      }

      // Handle body weight with fallbacks
      final bodyWeight = elder['body_weight'] ?? elder['bodyWeight'];
      if (bodyWeight != null) {
        try {
          final double weight = bodyWeight is num
              ? (bodyWeight as num).toDouble()
              : double.parse(bodyWeight.toString());
          _elderWeightController.text = weight.round().toString();
        } catch (e) {
          debugPrint('Error parsing body weight: $e');
        }
      }

      // Get photo URL
      if (elder['photo_url'] != null) {
        _elderPhotoUrl = elder['photo_url'];
      }
    });
  }

  void _populateCaregiverData(dynamic caregiverData) {
    if (caregiverData == null || caregiverData.isEmpty) return;

    final caregiver = caregiverData[0];
    setState(() {
      _caregiverData = caregiver;

      // Populate caregiver fields
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

      // Handle phone number with fallbacks
      final phoneNumber = caregiver['phone_number'] ?? caregiver['phoneNumber'];
      if (phoneNumber != null) {
        _caregiverPhoneController.text = phoneNumber.toString();
      }

      _caregiverRelationshipController.text = caregiver['relationship'] ?? '';

      // Get profile URL
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

  @override
  void dispose() {
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
        onConfirmed: onConfirmed,
        onCancelled: onConfirmed, // Currently both do the same thing
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
          // Handle save logic
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Failed to fetch user data: ${state.error}')),
              );
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Failed to fetch profile data: ${state.error}')),
              );
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
                  ProfileHeader(
                    isElder: switchValue,
                    elderImage: _elderImage,
                    caregiverImage: _caregiverImage,
                    elderPhotoUrl: _elderPhotoUrl,
                    caregiverPhotoUrl: _caregiverPhotoUrl,
                    elderData: _elderData,
                    caregiverData: _caregiverData,
                    onImagePick: _pickImageFromGallery,
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
                onPressed: () {
                  Navigator.pop(context);
                },
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
            onChanged: (value) => setState(() {
              switchValue = value;
            }),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : switchValue
                      ? ElderProfileView(
                          nameController: _elderNameController,
                          genderController: _elderGenderController,
                          birthdateController: _elderBirthdateController,
                          heightController: _elderHeightController,
                          weightController: _elderWeightController,
                        )
                      : CaregiverProfileView(
                          nameController: _caregiverNameController,
                          genderController: _caregiverGenderController,
                          birthdateController: _caregiverBirthdateController,
                          phoneController: _caregiverPhoneController,
                          relationshipController:
                              _caregiverRelationshipController,
                        ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _showEditDialog,
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
          )
        ],
      ),
    );
  }
}
