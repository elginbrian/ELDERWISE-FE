import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';

class PhotoProfile extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool isFinalStep;

  const PhotoProfile({
    super.key,
    required this.onNext,
    required this.onSkip,
    this.isFinalStep = false,
  });

  @override
  State<PhotoProfile> createState() => _PhotoProfileState();
}

class _PhotoProfileState extends State<PhotoProfile> {
  File? _elderImage;
  File? _caregiverImage;

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

  Widget _buildProfileImage({
    required File? imageFile,
    required VoidCallback onTap,
    required String title,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: AppColors.neutral90,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(75),
              border: Border.all(
                color: imageFile != null
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
                        Image.asset(iconImages + "plus.png"),
                        const Positioned(
                          bottom: 30,
                          child: Text(
                            "Tap to add photo",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.neutral70,
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Update to match others
        children: [
          // Add top padding to center vertically when screen is large enough
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),

          // Center the profile images
          Center(
            child: Column(
              children: [
                _buildProfileImage(
                  imageFile: _elderImage,
                  onTap: () => _pickImageFromGallery(true),
                  title: "Elder",
                ),
                const SizedBox(height: 32),
                _buildProfileImage(
                  imageFile: _caregiverImage,
                  onTap: () => _pickImageFromGallery(false),
                  title: "Caregiver",
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
                buttonText: widget.isFinalStep ? "Selesai" : "Selanjutnya",
                onTap: widget.onNext,
                color: AppColors.primaryMain,
              ),
              const SizedBox(height: 12),
              MainButton(
                buttonText: "Lewati",
                onTap: widget.onSkip,
                color: Colors.white,
              ),
            ],
          ),

          // Add some bottom padding
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
