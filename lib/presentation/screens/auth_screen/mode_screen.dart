import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:elderwise/presentation/bloc/user_mode/user_mode_bloc.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/utils/toast_helper.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primaryMain : AppColors.neutral30,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 32),
              child: Image.asset(iconImages + imageAsset, width: 70),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral90,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeUserMode() {
    if (_selectedRole == null) {
      ToastHelper.showErrorToast(context, "Silakan pilih mode terlebih dahulu");
      return;
    }

    final targetMode =
        _selectedRole == UserRole.elder ? UserMode.elder : UserMode.caregiver;

    context.read<UserModeBloc>().add(ToggleUserModeEvent(targetMode));

    ToastHelper.showSuccessToast(
      context,
      targetMode == UserMode.elder
          ? 'Mode Elder diaktifkan'
          : 'Mode Caregiver diaktifkan',
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondarySurface,
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              'lib/presentation/screens/assets/images/banner.png',
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppColors.secondarySurface,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32.0),
                          topRight: Radius.circular(32.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "Siapa Anda?",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.neutral90,
                                ),
                              ),
                              const SizedBox(height: 32),
                              buildRoleOption(
                                  UserRole.elder, "Elder", "elder.png"),
                              buildRoleOption(UserRole.caregiver, "Caregiver",
                                  "caregiver.png"),
                            ],
                          ),
                          MainButton(
                            buttonText: "Konfirmasi",
                            onTap: _changeUserMode,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
