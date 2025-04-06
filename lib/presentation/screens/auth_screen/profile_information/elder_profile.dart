import 'package:elderwise/domain/entities/elder.dart';
import 'package:elderwise/presentation/bloc/elder/elder_bloc.dart';
import 'package:elderwise/presentation/bloc/elder/elder_event.dart';
import 'package:elderwise/presentation/bloc/elder/elder_state.dart';
import 'package:elderwise/presentation/widgets/profile/custom_profile_field.dart';
import 'package:elderwise/presentation/widgets/profile/date_picker_field.dart';
import 'package:elderwise/presentation/widgets/profile/gender_selector.dart';
import 'package:elderwise/presentation/widgets/profile/measurement_field.dart';
import 'package:elderwise/presentation/widgets/profile/profile_action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class ElderProfile extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool isFinalStep;
  final String userId;

  const ElderProfile({
    super.key,
    required this.onNext,
    required this.onSkip,
    this.isFinalStep = false,
    required this.userId,
  });

  @override
  State<ElderProfile> createState() => _ElderProfileState();
}

class _ElderProfileState extends State<ElderProfile> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController tinggiController = TextEditingController();
  final TextEditingController beratController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;
  DateTime? _selectedDate;
  String? _selectedGender;

  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];

  @override
  void initState() {
    super.initState();
    genderController.addListener(_validateForm);
    tanggalLahirController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid = namaController.text.isNotEmpty &&
          genderController.text.isNotEmpty &&
          tanggalLahirController.text.isNotEmpty &&
          tinggiController.text.isNotEmpty &&
          beratController.text.isNotEmpty;
    });
  }

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
      genderController.text = gender;
    });
    _validateForm();
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    _validateForm();
  }

  void _submitForm() {
    if (!_isFormValid) return;

    // Ensure the birthdate has timezone information
    final DateTime birthdate = _selectedDate ?? DateTime.now();
    // Convert to UTC and ensure it has the correct format
    final DateTime formattedBirthdate = DateTime.utc(
      birthdate.year,
      birthdate.month,
      birthdate.day,
      0,
      0,
      0,
      0,
      0,
    );

    final elder = Elder(
      elderId: Uuid().v4(),
      userId: widget.userId,
      name: namaController.text,
      gender: genderController.text,
      birthdate: formattedBirthdate,
      bodyHeight: (int.tryParse(tinggiController.text) ?? 0).toDouble(),
      bodyWeight: (int.tryParse(beratController.text) ?? 0).toDouble(),
      photoUrl: '',
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    context.read<ElderBloc>().add(CreateElderEvent(elder));
  }

  @override
  void dispose() {
    namaController.dispose();
    genderController.dispose();
    tanggalLahirController.dispose();
    tinggiController.dispose();
    beratController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ElderBloc, ElderState>(
      listener: (context, state) {
        if (state is ElderSuccess) {
          if (!widget.isFinalStep) {
            widget.onNext();
          }
        } else if (state is ElderFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is ElderLoading;

        return Form(
          key: _formKey,
          onChanged: _validateForm,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomProfileField(
                  title: 'Nama Lengkap',
                  hintText: 'Masukkan nama elder',
                  controller: namaController,
                  icon: Icons.person,
                  onChanged: (_) => _validateForm(),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Nama tidak boleh kosong' : null,
                ),
                GenderSelector(
                  controller: genderController,
                  selectedGender: _selectedGender,
                  onGenderSelected: _selectGender,
                  genderOptions: _genderOptions,
                ),
                DatePickerField(
                  controller: tanggalLahirController,
                  selectedDate: _selectedDate,
                  onDateSelected: _selectDate,
                  placeholder: 'Pilih tanggal lahir elder',
                ),
                MeasurementField(
                  title: 'Tinggi Badan',
                  hint: 'Masukkan tinggi badan',
                  controller: tinggiController,
                  unit: 'cm',
                  onChanged: (_) => _validateForm(),
                ),
                MeasurementField(
                  title: 'Berat Badan',
                  hint: 'Masukkan berat badan',
                  controller: beratController,
                  unit: 'kg',
                  onChanged: (_) => _validateForm(),
                ),
                const SizedBox(height: 24),
                ProfileActionButtons(
                  isFormValid: _isFormValid,
                  onNext: () {
                    _submitForm();
                    if (widget.isFinalStep) widget.onNext();
                  },
                  onSkip: widget.onSkip,
                  isFinalStep: widget.isFinalStep,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
