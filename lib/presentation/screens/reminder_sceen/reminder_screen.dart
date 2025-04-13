import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:elderwise/presentation/widgets/notification/reminder_content.dart';
import 'package:flutter/material.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  final String type = "Makan";
  final String title = "Sayur Bayam";
  final String dose = "200 Gram";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondarySurface,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            ReminderContent(type: "Obat", title: "Sayur Bayam", dose: "1 Butir",),
            Column(
              children: [
                MainButton(buttonText: "Sudah"),
                SizedBox(height: 16,),
                MainButton(buttonText: "Abaikan", color: AppColors.neutral40,),
              ],
            )
          ],
        ),
      ),
    );
  }
}
