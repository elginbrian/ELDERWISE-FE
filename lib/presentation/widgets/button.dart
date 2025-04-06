import 'dart:ui';
import 'package:flutter/material.dart';
import '../screens/assets/image_string.dart';
import '../themes/colors.dart';

class MainButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final bool isLoading;
  final Color? color;
  final String? iconAsset;
  final TextAlign textAlign;

  const MainButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.isLoading = false,
    this.color = AppColors.primaryMain,
    this.iconAsset,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: color ?? AppColors.primaryMain,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 3),
              blurRadius: 2,
            ),
          ],
        ),
        child: isLoading
            ? const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              strokeWidth: 2.0,
            ),
          ),
        )
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: textAlign == TextAlign.center
                ? MainAxisAlignment.center
                : textAlign == TextAlign.left
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (iconAsset != null) ...[
                const SizedBox(width: 8),
                Image.asset(
                  iconImages + iconAsset!,
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 16),
              ],
              Text(
                buttonText,
                textAlign: textAlign,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: AppColors.neutral90,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
