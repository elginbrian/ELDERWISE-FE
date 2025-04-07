import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:flutter/material.dart';

class ProfileActionButtons extends StatelessWidget {
  final bool isFormValid;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool isFinalStep;
  final bool isLoading;
  final String buttonText;

  const ProfileActionButtons({
    Key? key,
    required this.isFormValid,
    required this.onNext,
    required this.onSkip,
    this.isFinalStep = false,
    this.isLoading = false,
    this.buttonText = 'Simpan',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MainButton(
            buttonText: buttonText,
            onTap: isFormValid ? onNext : () {},
            isLoading: isLoading,
            color: isFormValid ? AppColors.primaryMain : Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          MainButton(
            buttonText: 'Lewati',
            onTap: isLoading ? () {} : onSkip,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
