import 'dart:async';

import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/formfield.dart';
import 'package:flutter/material.dart';

class ElderProfile extends StatefulWidget {
  const ElderProfile({super.key});

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
    return Column(
      children: [
        const Text(
          "Profil Elder",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: AppColors.neutral90),
        ),
        const SizedBox(height: 24),
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
          keyboardType: TextInputType.number
        ),
      ],
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
    this.controller, required this.hintText, this.assetImage, this.isDate = false, this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
          SizedBox(height: 16,)
        ],
      ),
    );
  }
}


