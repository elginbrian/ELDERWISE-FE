import 'dart:io';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onTap;
  final String title;
  final bool isAvailable;

  const ProfileImagePicker({
    super.key,
    required this.imageFile,
    required this.onTap,
    required this.title,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
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
                        : AppColors.neutral80,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(75),
              child: imageFile != null
                  ? Stack(
                      children: [
                        Image.file(imageFile!,
                            fit: BoxFit.cover, width: 150, height: 150),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: onTap,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryMain,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              isAvailable
                                  ? "Tap untuk tambah foto"
                                  : "Profil belum dibuat",
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
                    ),
            ),
          ),
        ),
      ],
    );
  }

  static Future<File?> pickImage({
    required BuildContext context,
    required bool isElder,
  }) async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Pilih Sumber Foto'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, ImageSource.camera);
              },
              child: const Row(
                children: [
                  Icon(Icons.camera_alt, color: AppColors.primaryMain),
                  SizedBox(width: 10),
                  Text('Kamera'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, ImageSource.gallery);
              },
              child: const Row(
                children: [
                  Icon(Icons.photo_library, color: AppColors.primaryMain),
                  SizedBox(width: 10),
                  Text('Galeri'),
                ],
              ),
            ),
          ],
        );
      },
    );

    if (source != null) {
      final returnedImage = await ImagePicker().pickImage(source: source);
      if (returnedImage != null) {
        return File(returnedImage.path);
      }
    }
    return null;
  }
}
