import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';

class PhotoProfile extends StatefulWidget {
  const PhotoProfile({super.key});

  @override
  State<PhotoProfile> createState() => _PhotoProfileState();
}

class _PhotoProfileState extends State<PhotoProfile> {
  File? _elderImage;
  File? _caregiverImage;

  Future<void> _pickImageFromGallery(bool isElder) async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
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

  Widget _buildProfileImage({
    required File? imageFile,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(75),
          border: Border.all(
            color: imageFile != null ? AppColors.primaryMain : AppColors.neutral70,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(75),
          child: imageFile != null
              ? Image.file(imageFile, fit: BoxFit.cover)
              : Center(child: Image.asset(iconImages + "plus.png")),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Profile Elder",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
                color: AppColors.neutral90,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Elder",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: AppColors.neutral90,
              ),
            ),
            const SizedBox(height: 12),
            _buildProfileImage(
              imageFile: _elderImage,
              onTap: () => _pickImageFromGallery(true),
            ),
            const SizedBox(height: 32),
            const Text(
              "Caregiver",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: AppColors.neutral90,
              ),
            ),
            const SizedBox(height: 12),
            _buildProfileImage(
              imageFile: _caregiverImage,
              onTap: () => _pickImageFromGallery(false),
            ),
          ],
        ),
      ),
    );
  }
}
