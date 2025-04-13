import 'dart:ui';
import 'package:flutter/material.dart';
import '../screens/assets/image_string.dart';
import '../themes/colors.dart';

class MainButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onTap;
  final Color color;
  final Color textColor;
  final bool isLoading;
  final TextAlign textAlign;
  final String? iconAsset;
  final bool hasShadow;
  final bool hasBorder;
  final Color borderColor;

  const MainButton({
    super.key,
    required this.buttonText,
    this.onTap,
    this.color = AppColors.primaryMain,
    this.textColor = AppColors.neutral90,
    this.isLoading = false,
    this.textAlign = TextAlign.center,
    this.iconAsset,
    this.hasShadow = true,
    this.hasBorder = false,
    this.borderColor = AppColors.neutral30,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          border: hasBorder ? Border.all(color: borderColor, width: 1) : null,
          boxShadow: hasShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
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
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: textColor,
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
