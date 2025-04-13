import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class GreetingSection extends StatelessWidget {
  final String userName;
  final UserMode currentMode;

  const GreetingSection({
    Key? key,
    required this.userName,
    required this.currentMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: "Halo, ",
                  style: TextStyle(
                    color: AppColors.neutral90,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                  ),
                ),
                TextSpan(
                  text: userName,
                  style: const TextStyle(
                    color: AppColors.neutral90,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            currentMode == UserMode.elder
                ? "Lihat agenda hari ini!"
                : "Pantau aktivitas elder anda!",
            style: const TextStyle(
              color: AppColors.neutral90,
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
