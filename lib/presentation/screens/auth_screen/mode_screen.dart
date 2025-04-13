import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:flutter/material.dart';

enum UserRole { elder, caregiver }

class ModeScreen extends StatefulWidget {
  const ModeScreen({super.key});

  @override
  State<ModeScreen> createState() => _ModeScreenState();
}

class _ModeScreenState extends State<ModeScreen> {
  UserRole? _selectedRole;

  Widget buildRoleOption(UserRole role, String label, String imageAsset) {
  final bool isSelected = _selectedRole == role;
  return GestureDetector(
    onTap: () {
      setState(() {
        _selectedRole = role;
      });
    },
    child: Container(
      width: 300,
      height: 128,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.secondarySurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isSelected ? AppColors.primaryMain : AppColors.neutral40,
            spreadRadius: 3,
            blurRadius: 0,
            offset: const Offset(0, 0),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 48),
            child: Image.asset(iconImages + imageAsset, width: 70),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondarySurface,
      body: Column(
        children: [
          Image.asset(
            'lib/presentation/screens/assets/images/banner.png',
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        "Siapa Anda?",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        buildRoleOption(UserRole.elder, "Elder", "elder.png"),
                        buildRoleOption(UserRole.caregiver, "Caregiver", "caregiver.png"),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                  child: MainButton(
                    buttonText: "Konfirmasi",
                    onTap: () {
                      if (_selectedRole != null) {
                        // Contoh aksi, bisa ganti ke navigasi juga
                        print("Role yang dipilih: $_selectedRole");
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
