import 'package:elderwise/domain/entities/caregiver.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/screens/auth_screen/profile_information/caregiver_profile.dart';
import 'package:elderwise/presentation/screens/auth_screen/profile_information/elder_profile.dart';
import 'package:elderwise/presentation/screens/auth_screen/profile_information/photo_profile.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:flutter/material.dart';

class StepperScreen extends StatefulWidget {
  const StepperScreen({super.key});

  @override
  State<StepperScreen> createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondarySurface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent, 
                  hoverColor:
                      Colors.transparent,
                  icon: const Icon(Icons.arrow_back_ios,
                      color: AppColors.neutral90),
                  onPressed: () {
                    if (currentStep > 0) {
                      setState(() => currentStep -= 1);
                    }
                  },
                ),
              ),
              title: const Text(
                "Atur Profile",
                style:
                    TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentStep == 0
                          ? AppColors.primaryMain
                          : Colors.grey.shade300,
                      border: Border.all(
                        color: currentStep == 0
                            ? AppColors.primaryMain
                            : Colors.grey.shade300,
                        width: 2.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "1",
                        style: TextStyle(
                          color: currentStep == 0 ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 2,
                    color: Colors.grey.shade300,
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentStep == 1
                          ? AppColors.primaryMain
                          : Colors.grey.shade300,
                      border: Border.all(
                        color: currentStep == 1
                            ? AppColors.primaryMain
                            : Colors.grey.shade300,
                        width: 2.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "2",
                        style: TextStyle(
                          color: currentStep == 1 ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 2,
                    color: Colors.grey.shade300,
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentStep == 2
                          ? AppColors.primaryMain
                          : Colors.grey.shade300,
                      border: Border.all(
                        color: currentStep == 2
                            ? AppColors.primaryMain
                            : Colors.grey.shade300,
                        width: 2.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "3",
                        style: TextStyle(
                          color: currentStep == 2 ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: currentStep,
                children: const [
                  ElderProfile(),
                  CaregiverProfile(),
                  PhotoProfile(),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MainButton(
                  buttonText: "Selanjutnya",
                  onTap: () {
                    if (currentStep < 2) {
                      setState(() => currentStep += 1);
                    } else {}
                  },
                  color: AppColors.primaryMain,
                ),
                const SizedBox(height: 16),
                MainButton(
                  buttonText: "Lewati",
                  onTap: () {
                      if (currentStep < 2) {
                      setState(() => currentStep += 1);
                    } else {}
                  },
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
