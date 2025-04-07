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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomProfileField(
          title: 'Nama Lengkap',
          hintText: 'Nama elder',
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
          placeholder: 'Tanggal lahir elder',
          readOnly: readOnly,
        ),
        MeasurementField(
          title: 'Tinggi Badan',
          hint: 'Tinggi badan',
          controller: heightController,
          unit: 'cm',
          readOnly: readOnly,
        ),
        MeasurementField(
          title: 'Berat Badan',
          hint: 'Berat badan',
          controller: weightController,
          unit: 'kg',
          readOnly: readOnly,
        ),
      ],
    );
  }
}
