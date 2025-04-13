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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomProfileField(
          title: 'Nama Lengkap',
          hintText: 'Masukkan nama anda',
          controller: nameController,
          icon: Icons.person,
          readOnly: readOnly,
        ),
        GenderSelector(
          controller: genderController,
          selectedGender:
              genderController.text.isEmpty ? null : genderController.text,
          onGenderSelected: (gender) {
            genderController.text = gender;
          },
          readOnly: readOnly,
        ),
        DatePickerField(
          controller: birthdateController,
          selectedDate: _parseDate(birthdateController.text),
          onDateSelected: (date) {
            final day = date.day.toString().padLeft(2, '0');
            final month = date.month.toString().padLeft(2, '0');
            final year = date.year.toString();
            birthdateController.text = "$day/$month/$year";
          },
          placeholder: 'Tanggal lahir caregiver',
          readOnly: readOnly,
        ),
        CustomProfileField(
          title: 'No. Telepon',
          hintText: 'Masukkan nomor telepon anda',
          controller: phoneController,
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          readOnly: readOnly,
        ),
        RelationshipSelector(
          controller: relationshipController,
          selectedRelationship: relationshipController.text.isEmpty
              ? null
              : relationshipController.text,
          onRelationshipSelected: (relationship) {
            relationshipController.text = relationship;
          },
          relationshipOptions: const ['Anak', 'Cucu', 'Saudara', 'Lainnya'],
          readOnly: readOnly,
        ),
      ],
    );
  }

  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) return null;

    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
      }
    } catch (e) {
      debugPrint('Error parsing date: $e');
    }
    return null;
  }
}
