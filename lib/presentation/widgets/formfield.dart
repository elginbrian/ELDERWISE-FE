import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/assets/image_string.dart';
import '../themes/colors.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final dynamic icon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Color borderColor;
  final FontWeight fontWeight;
  final bool isDate;
  final Function(DateTime?)? onDateSelected;

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
    this.isDate = false,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      inputFormatters: keyboardType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      style: TextStyle(
        fontSize: 12,
        fontWeight: fontWeight,
        fontFamily: 'Poppins',
        color: AppColors.neutral90,
      ),
      readOnly: isDate,
      onTap: isDate
          ? () async {
              FocusScope.of(context).requestFocus(FocusNode());
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.primaryMain,
                        onPrimary: Colors.white,
                        onSurface: AppColors.neutral90,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryMain,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                controller?.text =
                    "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                onDateSelected?.call(pickedDate);
              }
            }
          : null,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 12,
          fontWeight: fontWeight,
          fontFamily: 'Poppins',
          color: AppColors.neutral80,
        ),
        prefixIcon: _buildIcon(),
        contentPadding: icon != null
            ? const EdgeInsets.symmetric(vertical: 0, horizontal: 0)
            : const EdgeInsets.symmetric(vertical: 0, horizontal: 32),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: AppColors.neutral80, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: AppColors.neutral80, width: 1),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (icon is IconData) {
      return Icon(
        icon as IconData,
        color: AppColors.neutral60,
        size: 20,
      );
    } else if (icon is String) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(
          '${iconImages}${icon as String}',
          width: 20,
          height: 20,
          color: AppColors.neutral60,
        ),
      );
    } else {
      return const SizedBox(width: 20, height: 20);
    }
  }
}
