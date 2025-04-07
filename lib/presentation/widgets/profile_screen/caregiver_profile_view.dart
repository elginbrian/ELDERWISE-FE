import 'package:elderwise/presentation/widgets/profile/custom_profile_field.dart';
import 'package:elderwise/presentation/widgets/profile/date_picker_field.dart';
import 'package:elderwise/presentation/widgets/profile/gender_selector.dart';
import 'package:elderwise/presentation/widgets/profile/relationship_selector.dart';
import 'package:flutter/material.dart';

class CaregiverProfileView extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController genderController;
  final TextEditingController birthdateController;
  final TextEditingController phoneController;
  final TextEditingController relationshipController;
  final bool readOnly;

  const CaregiverProfileView({
    Key? key,
    required this.nameController,
    required this.genderController,
    required this.birthdateController,
    required this.phoneController,
    required this.relationshipController,
    this.readOnly = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomProfileField(
          title: 'Nama Lengkap',
          hintText: 'Nama caregiver',
          controller: nameController,
          icon: Icons.person,
          readOnly: readOnly,
        ),
        GenderSelector(
          controller: genderController,
          selectedGender: genderController.text,
          onGenderSelected: (_) {},
          readOnly: readOnly,
        ),
        DatePickerField(
          controller: birthdateController,
          selectedDate: null,
          onDateSelected: (_) {},
          placeholder: 'Tanggal lahir caregiver',
          readOnly: readOnly,
        ),
        CustomProfileField(
          title: 'No. Telepon',
          hintText: 'Nomor telepon',
          icon: Icons.phone,
          controller: phoneController,
          readOnly: readOnly,
        ),
        RelationshipSelector(
          controller: relationshipController,
          selectedRelationship: relationshipController.text,
          onRelationshipSelected: (_) {},
          relationshipOptions: const [
            'Anak',
            'Saudara',
            'Cucu',
            'Lainnya',
          ],
          readOnly: readOnly,
        ),
      ],
    );
  }
}
