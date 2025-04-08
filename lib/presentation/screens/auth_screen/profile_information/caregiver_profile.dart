import 'package:elderwise/domain/entities/caregiver.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_bloc.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_event.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_state.dart';
import 'package:elderwise/presentation/bloc/user/user_bloc.dart';
import 'package:elderwise/presentation/bloc/user/user_event.dart';
import 'package:elderwise/presentation/bloc/user/user_state.dart';
import 'package:elderwise/presentation/widgets/profile/custom_profile_field.dart';
import 'package:elderwise/presentation/widgets/profile/date_picker_field.dart';
import 'package:elderwise/presentation/widgets/profile/gender_selector.dart';
import 'package:elderwise/presentation/widgets/profile/profile_action_buttons.dart';
import 'package:elderwise/presentation/widgets/profile/relationship_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:elderwise/presentation/utils/toast_helper.dart';

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
  String? _caregiverId;
  bool _isEditing = false;
  bool _isCheckingUser = true;

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

    // Check if user already has a caregiver profile
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserBloc>().add(GetUserCaregiversEvent(widget.userId));
    });
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

  void _populateFormWithCaregiverData(dynamic caregiverData) {
    if (caregiverData == null || caregiverData.isEmpty) return;

    final caregiver = caregiverData[0];

    debugPrint('Caregiver data received: $caregiver');

    setState(() {
      _caregiverId = caregiver['caregiver_id'] ?? caregiver['id'] ?? '';
      _isEditing = true;

      namaController.text = caregiver['name'] ?? '';

      if (caregiver['gender'] != null) {
        _selectedGender = caregiver['gender'];
        genderController.text = caregiver['gender'];
      }

      if (caregiver['birthdate'] != null) {
        try {
          _selectedDate = DateTime.parse(caregiver['birthdate']);
          tanggalLahirController.text =
              "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
        } catch (e) {
          debugPrint('Error parsing birthdate: $e');
        }
      }

      // Try both snake_case and camelCase field names for phone number
      final phoneNumber = caregiver['phone_number'] ?? caregiver['phoneNumber'];
      if (phoneNumber != null) {
        try {
          teleponController.text = phoneNumber.toString();
          debugPrint(
              'Successfully set phone number: ${teleponController.text}');
        } catch (e) {
          debugPrint('Error parsing phone number: $e');
          teleponController.text = '';
        }
      } else {
        debugPrint('Phone number field not found in data');
      }

      if (caregiver['relationship'] != null) {
        _selectedRelationship = caregiver['relationship'];
        relationshipController.text = caregiver['relationship'];
      }
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
      caregiverId: _isEditing ? _caregiverId! : Uuid().v4(),
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

    if (_isEditing) {
      context
          .read<CaregiverBloc>()
          .add(UpdateCaregiverEvent(_caregiverId!, caregiver));
    } else {
      context.read<CaregiverBloc>().add(CreateCaregiverEvent(caregiver));
    }
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
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserSuccess) {
              setState(() => _isCheckingUser = false);

              if (state.response.data != null &&
                  state.response.data is Map &&
                  state.response.data.containsKey('caregivers')) {
                _populateFormWithCaregiverData(
                    state.response.data['caregivers']);
              }
            } else if (state is UserFailure) {
              setState(() => _isCheckingUser = false);
              ToastHelper.showErrorToast(context, state.error);
            }
          },
        ),
        BlocListener<CaregiverBloc, CaregiverState>(
          listener: (context, state) {
            if (state is CaregiverSuccess) {
              if (!widget.isFinalStep) {
                widget.onNext();
              }
            } else if (state is CaregiverFailure) {
              ToastHelper.showErrorToast(context, state.error);
            }
          },
        ),
      ],
      child: BlocBuilder<CaregiverBloc, CaregiverState>(
        builder: (context, caregiverState) {
          final bool isLoading =
              caregiverState is CaregiverLoading || _isCheckingUser;

          if (isLoading && _isCheckingUser) {
            return const Center(child: CircularProgressIndicator());
          }

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
                    buttonText: _isEditing ? 'Update' : 'Simpan',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
