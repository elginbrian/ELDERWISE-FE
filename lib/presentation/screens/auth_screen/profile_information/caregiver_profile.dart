import 'package:elderwise/presentation/screens/auth_screen/profile_information/elder_profile.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:flutter/material.dart';

class CaregiverProfile extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool isFinalStep;

  const CaregiverProfile({
    super.key,
    required this.onNext,
    required this.onSkip,
    this.isFinalStep = false,
  });

  @override
  State<CaregiverProfile> createState() => _CaregiverProfileState();
}

class _CaregiverProfileState extends State<CaregiverProfile> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();

  @override
  void dispose() {
    namaController.dispose();
    genderController.dispose();
    tanggalLahirController.dispose();
    teleponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Changed from start to stretch
        children: [
          // Form fields
          CustomProfileField(
            title: 'Nama Lengkap',
            hintText: 'Masukkan nama anda',
            controller: namaController,
          ),
          CustomProfileField(
            title: 'Jenis Kelamin',
            hintText: 'Masukkan jenis kelamin anda',
            controller: genderController,
          ),
          CustomProfileField(
            title: 'Tanggal Lahir',
            hintText: 'Masukkan tanggal lahir anda',
            assetImage: 'date.png',
            isDate: true,
            controller: tanggalLahirController,
          ),
          CustomProfileField(
            title: 'No. Telepon',
            hintText: 'Masukkan nomor telepon anda',
            assetImage: 'phone.png',
            controller: teleponController,
            keyboardType: TextInputType.number,
          ),

          // Add spacing before buttons
          const SizedBox(height: 24),

          // Navigation buttons now inside the scrollable area
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

          // Add some bottom padding
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
