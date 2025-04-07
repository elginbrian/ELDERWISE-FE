import 'dart:io';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final bool isElder;
  final File? elderImage;
  final File? caregiverImage;
  final String? elderPhotoUrl;
  final String? caregiverPhotoUrl;
  final dynamic elderData;
  final dynamic caregiverData;
  final Function(bool) onImagePick;

  const ProfileHeader({
    Key? key,
    required this.isElder,
    this.elderImage,
    this.caregiverImage,
    this.elderPhotoUrl,
    this.caregiverPhotoUrl,
    this.elderData,
    this.caregiverData,
    required this.onImagePick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 42, top: 42),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildProfileImage(),
          const SizedBox(width: 16),
          _buildProfileInfo(),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            image: DecorationImage(
              image: _getProfileImage(),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => onImagePick(isElder),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.secondarySurface,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.edit,
                color: AppColors.primaryMain,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    final String name = isElder
        ? (elderData != null ? elderData['name'] ?? "Elder" : "Elder")
        : (caregiverData != null
            ? caregiverData['name'] ?? "Caregiver"
            : "Caregiver");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: AppColors.neutral100,
          ),
        ),
        Text(
          isElder ? "Elder" : "Caregiver",
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: AppColors.neutral90,
          ),
        ),
      ],
    );
  }

  ImageProvider _getProfileImage() {
    if (isElder) {
      if (elderImage != null) {
        return FileImage(elderImage!);
      } else if (elderPhotoUrl != null && elderPhotoUrl!.isNotEmpty) {
        return NetworkImage(elderPhotoUrl!);
      }
    } else {
      if (caregiverImage != null) {
        return FileImage(caregiverImage!);
      } else if (caregiverPhotoUrl != null && caregiverPhotoUrl!.isNotEmpty) {
        return NetworkImage(caregiverPhotoUrl!);
      }
    }
    return const AssetImage(
        'lib/presentation/screens/assets/images/onboard.png');
  }
}
