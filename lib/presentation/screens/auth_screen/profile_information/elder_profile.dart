import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/formfield.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:flutter/material.dart';

class ElderProfile extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool isFinalStep;

  const ElderProfile({
    super.key,
    required this.onNext,
    required this.onSkip,
    this.isFinalStep = false,
  });

  @override
  State<ElderProfile> createState() => _ElderProfileState();
}

class _ElderProfileState extends State<ElderProfile> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController tinggiController = TextEditingController();
  final TextEditingController beratController = TextEditingController();

  @override
  void dispose() {
    namaController.dispose();
    genderController.dispose();
    tanggalLahirController.dispose();
    tinggiController.dispose();
    beratController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Changed from start to stretch
        children: [
          CustomProfileField(
            title: 'Nama Lengkap',
            hintText: 'Masukkan nama elder',
            controller: namaController,
          ),
          CustomProfileField(
            title: 'Jenis Kelamin',
            hintText: 'Masukkan jenis kelamin elder',
            controller: genderController,
          ),
          CustomProfileField(
            title: 'Tanggal Lahir',
            hintText: 'Masukkan tanggal lahir elder',
            assetImage: 'date.png',
            isDate: true,
            controller: tanggalLahirController,
          ),
          CustomProfileField(
            title: 'Tinggi Badan',
            hintText: 'Masukkan tinggi badan elder',
            controller: tinggiController,
            keyboardType: TextInputType.number,
          ),
          CustomProfileField(
            title: 'Berat Badan',
            hintText: 'Masukkan berat badan elder',
            controller: beratController,
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

class CustomProfileField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController? controller;
  final String? assetImage;
  final bool isDate;
  final TextInputType keyboardType;

  const CustomProfileField({
    super.key,
    required this.title,
    this.controller,
    required this.hintText,
    this.assetImage,
    this.isDate = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: AppColors.neutral90,
          ),
        ),
        const SizedBox(height: 8),
        CustomFormField(
          hintText: hintText,
          controller: controller,
          icon: assetImage,
          isDate: isDate,
          keyboardType: keyboardType,
        ),
        const SizedBox(height: 16)
      ],
    );
  }
}
