import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:flutter/material.dart';

class FallScreen extends StatelessWidget {
  const FallScreen({super.key});

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
                      "lib/presentation/screens/assets/images/illust2.png"),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 8),
                    child: Text(
                      "Apakah anda baik-baik saja?",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    "Saya mendeteksi bahwa ponsel anda terjatuh",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                MainButton(buttonText: "Ya, saya baik-baik saja"),
                SizedBox(
                  height: 16,
                ),
                MainButton(
                  buttonText: "Tidak, saya butuh bantuan",
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
