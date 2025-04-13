import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class ElderGreetingSection extends StatelessWidget {
  final String userName;

  const ElderGreetingSection({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 112.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            const Text(
              "Apa kabar anda hari ini?",
              style: TextStyle(
                color: AppColors.neutral90,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
