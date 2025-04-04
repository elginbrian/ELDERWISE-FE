import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/assets/image_string.dart';
import '../themes/colors.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final String? icon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Color borderColor;
  final FontWeight fontWeight;

  const CustomFormField({
    super.key,
    required this.hintText,
    this.icon,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.borderColor = AppColors.neutral80,
    this.fontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 12,
          fontWeight: fontWeight,
          fontFamily: 'Poppins',
          color: AppColors.neutral90,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 12,
            fontWeight: fontWeight,
            fontFamily: 'Poppins',
            color: AppColors.neutral80,
          ),
          prefixIcon: icon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                  child: Image.asset(iconImages + icon!, height: 18),
                )
              : null,
          contentPadding: icon != null
              ? const EdgeInsets.symmetric(vertical: 0, horizontal: 0)
              : const EdgeInsets.symmetric(vertical: 0, horizontal: 32),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide(
              color: borderColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(
              color: AppColors.neutral80,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
