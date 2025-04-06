import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:flutter/material.dart';

class ProfileActionButtons extends StatelessWidget {
  final bool isFormValid;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool isFinalStep;
  final bool isLoading;

  const ProfileActionButtons({
    super.key,
    required this.isFormValid,
    required this.onNext,
    required this.onSkip,
    this.isFinalStep = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MainButton(
          buttonText: isFinalStep ? "Selesai" : "Selanjutnya",
          onTap: isFormValid ? onNext : () {},
          color: isFormValid ? AppColors.primaryMain : AppColors.neutral30,
          isLoading: isLoading,
        ),
        const SizedBox(height: 12),
        MainButton(
          buttonText: "Lewati",
          onTap: onSkip,
          color: Colors.white,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
