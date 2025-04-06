import 'package:elderwise/presentation/screens/auth_screen/profile_information/elder_profile.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class CaregiverProfile extends StatefulWidget {
  const CaregiverProfile({super.key});

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
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(.0),
          child: Column(
            children: [
              Text(
                "Profile Caregiver",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: AppColors.neutral90,
                ),
              ),
              SizedBox(height: 24),
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
            ],
          ),
        ),
      ),
    );
  }
}
