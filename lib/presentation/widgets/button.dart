import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes/colors.dart';

class MainButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final bool isLoading;
  final Color? color;

  const MainButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.isLoading = false,
    this.color = AppColors.primaryMain,
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
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    strokeWidth: 2.0,
                  ),
                )
              : Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: AppColors.neutral90,
                    fontFamily: 'Poppins',
                  ),
                ),
        ),
      ),
    );
  }
}
