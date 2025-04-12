import 'package:flutter/material.dart';
import 'package:elderwise/presentation/themes/colors.dart';

class StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;

  const StyledTextField({
    Key? key,
    required this.controller,
    required this.title,
    required this.hintText,
    required this.icon,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: AppColors.neutral90,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutral80),
            borderRadius: BorderRadius.circular(32),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 12.0),
                child: Icon(icon, size: 20, color: AppColors.neutral80),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    color: AppColors.neutral90,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      color: AppColors.neutral80,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  validator: validator,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
