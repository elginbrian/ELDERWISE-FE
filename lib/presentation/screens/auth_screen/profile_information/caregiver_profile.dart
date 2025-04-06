import 'package:elderwise/domain/entities/caregiver.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_bloc.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_event.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_state.dart';
import 'package:elderwise/presentation/widgets/profile/custom_profile_field.dart';
import 'package:elderwise/presentation/widgets/profile/date_picker_field.dart';
import 'package:elderwise/presentation/widgets/profile/gender_selector.dart';
import 'package:elderwise/presentation/widgets/profile/profile_action_buttons.dart';
import 'package:elderwise/presentation/widgets/profile/relationship_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class CaregiverProfile extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool isFinalStep;
  final String userId;

  const CaregiverProfile({
    super.key,
    required this.onNext,
    required this.onSkip,
    this.isFinalStep = false,
    required this.userId,
  });

  @override
  State<CaregiverProfile> createState() => _CaregiverProfileState();
}

class _CaregiverProfileState extends State<CaregiverProfile> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController relationshipController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;
  DateTime? _selectedDate;
  String? _selectedGender;
  String? _selectedRelationship;

  final List<String> _relationshipOptions = [
    'Anak',
    'Cucu',
    'Saudara',
    'Lainnya'
  ];

  @override
  void initState() {
    super.initState();
    genderController.addListener(_validateForm);
    tanggalLahirController.addListener(_validateForm);
    relationshipController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid = namaController.text.isNotEmpty &&
          genderController.text.isNotEmpty &&
          tanggalLahirController.text.isNotEmpty &&
          teleponController.text.isNotEmpty &&
          relationshipController.text.isNotEmpty;
    });
  }

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
      genderController.text = gender;
    });
    _validateForm();
  }

  void _selectRelationship(String relationship) {
    setState(() {
      _selectedRelationship = relationship;
      relationshipController.text = relationship;
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

    final caregiver = Caregiver(
      caregiverId: Uuid().v4(),
      userId: widget.userId,
      name: namaController.text,
      gender: genderController.text,
      birthdate: _selectedDate ?? DateTime.now(),
      phoneNumber: teleponController.text,
      profileUrl: '',
      relationship: relationshipController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    context.read<CaregiverBloc>().add(CreateCaregiverEvent(caregiver));
  }

  @override
  void dispose() {
    namaController.dispose();
    genderController.dispose();
    tanggalLahirController.dispose();
    teleponController.dispose();
    relationshipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CaregiverBloc, CaregiverState>(
      listener: (context, state) {
        if (state is CaregiverSuccess) {
          if (!widget.isFinalStep) {
            widget.onNext();
          }
        } else if (state is CaregiverFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Form(
              key: _formKey,
              onChanged: _validateForm,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomProfileField(
                      title: 'Nama Lengkap',
                      hintText: 'Masukkan nama anda',
                      controller: namaController,
                      onChanged: (_) => _validateForm(),
                      icon: Icons.person,
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Nama tidak boleh kosong'
                          : null,
                    ),

                    GenderSelector(
                      controller: genderController,
                      selectedGender: _selectedGender,
                      onGenderSelected: _selectGender,
                    ),

                    DatePickerField(
                      controller: tanggalLahirController,
                      selectedDate: _selectedDate,
                      onDateSelected: _selectDate,
                      placeholder: 'Pilih tanggal lahir anda',
                    ),

                    // Phone number field
                    CustomProfileField(
                      title: 'No. Telepon',
                      hintText: 'Masukkan nomor telepon anda',
                      icon: Icons.phone,
                      controller: teleponController,
                      keyboardType: TextInputType.phone,
                      onChanged: (_) => _validateForm(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor telepon tidak boleh kosong';
                        }
                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                          return 'Nomor telepon hanya boleh berisi angka';
                        }
                        return null;
                      },
                    ),

                    // Relationship Dropdown
                    RelationshipSelector(
                      controller: relationshipController,
                      selectedRelationship: _selectedRelationship,
                      onRelationshipSelected: _selectRelationship,
                      relationshipOptions: _relationshipOptions,
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
                    ),
                  ],
                ),
              ),
            ),
            // Show loading indicator
            if (state is CaregiverLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      },
    );
  }
}
