import 'package:elderwise/presentation/screens/auth_screen/profile_information/elder_profile.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class CaregiverProfile extends StatefulWidget {
  const CaregiverProfile({super.key});

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

    final DateTime birthdate = _selectedDate ?? DateTime.now();
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

    final caregiver = Caregiver(
      caregiverId: Uuid().v4(),
      userId: widget.userId,
      name: namaController.text,
      gender: genderController.text,
      birthdate: formattedBirthdate,
      phoneNumber: teleponController.text,
      profileUrl: '',
      relationship: relationshipController.text,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    context.read<CaregiverBloc>().add(CreateCaregiverEvent(caregiver));
  }

  @override
  void dispose() {
    namaController.dispose();
    genderController.dispose();
    tanggalLahirController.dispose();
    teleponController.dispose();
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
        final bool isLoading = state is CaregiverLoading;

        return Form(
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
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Nama tidak boleh kosong' : null,
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
