import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class FenceInfoWidget extends StatelessWidget {
  final String centerPoint;
  final double mandiriRadius;
  final double pantauRadius;

  const FenceInfoWidget({
    Key? key,
    required this.centerPoint,
    required this.mandiriRadius,
    required this.pantauRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Titik Pusat       :  $centerPoint",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: AppColors.neutral90,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Area Mandiri  :  ${mandiriRadius.toStringAsFixed(1)} Km",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: AppColors.neutral90,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Area Pantau   :  ${pantauRadius.toStringAsFixed(1)} Km",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: AppColors.neutral90,
          ),
        ),
      ],
    );
  }
}
