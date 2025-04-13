import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:elderwise/presentation/bloc/user_mode/user_mode_bloc.dart';
import 'package:elderwise/presentation/widgets/profile/custom_profile_field.dart';
import 'package:elderwise/presentation/widgets/profile/date_picker_field.dart';
import 'package:elderwise/presentation/widgets/profile/gender_selector.dart';
import 'package:elderwise/presentation/widgets/profile/measurement_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final userModeState = context.watch<UserModeBloc>().state;
    final isElderMode = userModeState.userMode == UserMode.elder;

    // Force readOnly in Elder Mode
    final bool actualReadOnly = isElderMode ? true : readOnly;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomProfileField(
          title: 'Nama Lengkap',
          hintText: 'Masukkan nama elder',
          controller: nameController,
          icon: Icons.person,
          readOnly: actualReadOnly,
        ),
        GenderSelector(
          controller: genderController,
          selectedGender:
              genderController.text.isEmpty ? null : genderController.text,
          onGenderSelected: (gender) {
            genderController.text = gender;
          },
          readOnly: actualReadOnly,
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
          readOnly: actualReadOnly,
        ),
        MeasurementField(
          title: 'Tinggi Badan',
          hint: 'Masukkan tinggi badan',
          controller: heightController,
          unit: 'cm',
          readOnly: actualReadOnly,
        ),
        MeasurementField(
          title: 'Berat Badan',
          hint: 'Masukkan berat badan',
          controller: weightController,
          unit: 'kg',
          readOnly: actualReadOnly,
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
