import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:flutter/material.dart';

class CrossingScreenCaregiver extends StatelessWidget {
  const CrossingScreenCaregiver({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondarySurface,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                      "lib/presentation/screens/assets/images/illust3.png"),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 8),
                    child: Text(
                      "Elder melewati area aman!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                MainButton(buttonText: "Beri Notifikasi"),
                SizedBox(
                  height: 16,
                ),
                MainButton(
                  buttonText: "Abaikan",
                  color: AppColors.neutral40,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
