
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes/colors.dart';

class BioField extends StatelessWidget {
  final String title;
  final String content;
  final bool isEditable;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  const BioField({
    super.key,
    required this.title,
    required this.content,
    this.isEditable = false,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: AppColors.neutral80,
            )),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.neutral10,
            borderRadius: BorderRadius.circular(24),
          ),
          child: isEditable
              ? TextFormField(
            controller: controller,
            initialValue: controller == null ? content : null,
            onChanged: onChanged,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: AppColors.neutral80,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          )
              : Align(
            alignment: Alignment.centerLeft,
            child: Text(
              content,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: AppColors.neutral80,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
