import 'package:elderwise/presentation/widgets/profile/custom_profile_field.dart';
import 'package:elderwise/presentation/widgets/profile/date_picker_field.dart';
import 'package:elderwise/presentation/widgets/profile/gender_selector.dart';
import 'package:elderwise/presentation/widgets/profile/measurement_field.dart';
import 'package:flutter/material.dart';

class ElderProfileView extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController genderController;
  final TextEditingController birthdateController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final bool readOnly;

  const ElderProfileView({
    Key? key,
    required this.nameController,
    required this.genderController,
    required this.birthdateController,
    required this.heightController,
    required this.weightController,
    this.readOnly = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomProfileField(
          title: 'Nama Lengkap',
          hintText: 'Masukkan nama elder',
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
          placeholder: 'Tanggal lahir elder',
          readOnly: readOnly,
        ),
        MeasurementField(
          title: 'Tinggi Badan',
          hint: 'Masukkan tinggi badan',
          controller: heightController,
          unit: 'cm',
          readOnly: readOnly,
        ),
        MeasurementField(
          title: 'Berat Badan',
          hint: 'Masukkan berat badan',
          controller: weightController,
          unit: 'kg',
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
