import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:flutter/material.dart';

class CrossingScreen extends StatelessWidget {
  const CrossingScreen({super.key});

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
                      "Anda melewati area aman",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    "Notifikasi akan dikirimkan ke caregiver",
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
                MainButton(buttonText: "Baiklah"),
                
              ],
            )
          ],
        ),
      ),
    );
  }
}
