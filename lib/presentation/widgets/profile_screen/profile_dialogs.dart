import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:elderwise/presentation/widgets/profile_screen/caregiver_profile_view.dart';
import 'package:elderwise/presentation/widgets/profile_screen/elder_profile_view.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirmed;
  final VoidCallback onCancelled;

  const ConfirmationDialog({
    Key? key,
    required this.onConfirmed,
    required this.onCancelled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.neutral20,
          borderRadius: BorderRadius.circular(32),
        ),
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Simpan Perubahan?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: AppColors.neutral90,
                ),
              ),
              const SizedBox(height: 32),
              MainButton(
                buttonText: "Simpan",
                onTap: onConfirmed,
              ),
              const SizedBox(height: 16),
              MainButton(
                buttonText: "Batal",
                color: AppColors.secondarySurface,
                onTap: onCancelled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfileDialog extends StatelessWidget {
  final bool isElder;
  final TextEditingController elderNameController;
  final TextEditingController elderGenderController;
  final TextEditingController elderBirthdateController;
  final TextEditingController elderHeightController;
  final TextEditingController elderWeightController;
  final TextEditingController caregiverNameController;
  final TextEditingController caregiverGenderController;
  final TextEditingController caregiverBirthdateController;
  final TextEditingController caregiverPhoneController;
  final TextEditingController caregiverRelationshipController;
  final VoidCallback onSave;
  final Function(VoidCallback) showConfirmationDialog;

  const EditProfileDialog({
    Key? key,
    required this.isElder,
    required this.elderNameController,
    required this.elderGenderController,
    required this.elderBirthdateController,
    required this.elderHeightController,
    required this.elderWeightController,
    required this.caregiverNameController,
    required this.caregiverGenderController,
    required this.caregiverBirthdateController,
    required this.caregiverPhoneController,
    required this.caregiverRelationshipController,
    required this.onSave,
    required this.showConfirmationDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: AppColors.neutral20,
          borderRadius: BorderRadius.circular(32),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16, bottom: 32.0),
                child: Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: AppColors.neutral90,
                  ),
                ),
              ),
              if (isElder)
                ElderProfileView(
                  nameController: elderNameController,
                  genderController: elderGenderController,
                  birthdateController: elderBirthdateController,
                  heightController: elderHeightController,
                  weightController: elderWeightController,
                  readOnly: false,
                )
              else
                CaregiverProfileView(
                  nameController: caregiverNameController,
                  genderController: caregiverGenderController,
                  birthdateController: caregiverBirthdateController,
                  phoneController: caregiverPhoneController,
                  relationshipController: caregiverRelationshipController,
                  readOnly: false,
                ),
              const SizedBox(height: 16),
              MainButton(
                buttonText: "Simpan",
                onTap: () => showConfirmationDialog(onSave),
              ),
              const SizedBox(height: 16),
              MainButton(
                buttonText: "Batal",
                color: AppColors.secondarySurface,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
