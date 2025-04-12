import 'package:elderwise/domain/entities/elder.dart';
import 'package:elderwise/presentation/bloc/elder/elder_bloc.dart';
import 'package:elderwise/presentation/bloc/elder/elder_event.dart';
import 'package:elderwise/presentation/bloc/elder/elder_state.dart';
import 'package:elderwise/presentation/bloc/user/user_bloc.dart';
import 'package:elderwise/presentation/bloc/user/user_event.dart';
import 'package:elderwise/presentation/bloc/user/user_state.dart';
import 'package:elderwise/presentation/widgets/profile/custom_profile_field.dart';
import 'package:elderwise/presentation/widgets/profile/date_picker_field.dart';
import 'package:elderwise/presentation/widgets/profile/gender_selector.dart';
import 'package:elderwise/presentation/widgets/profile/measurement_field.dart';
import 'package:elderwise/presentation/widgets/profile/profile_action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:elderwise/presentation/utils/toast_helper.dart';

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
  String? _elderId;
  bool _isEditing = false;
  bool _isCheckingUser = true;

  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];

  @override
  void initState() {
    super.initState();
    genderController.addListener(_validateForm);
    tanggalLahirController.addListener(_validateForm);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserBloc>().add(GetUserEldersEvent(widget.userId));
    });
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

  void _populateFormWithElderData(dynamic elderData) {
    if (elderData == null || elderData.isEmpty) return;

    final elder = elderData[0];

    debugPrint('Elder data received: $elder');

    setState(() {
      _elderId = elder['elder_id'] ?? elder['id'] ?? '';
      _isEditing = true;

      namaController.text = elder['name'] ?? '';

      if (elder['gender'] != null) {
        _selectedGender = elder['gender'];
        genderController.text = elder['gender'];
      }

      if (elder['birthdate'] != null) {
        try {
          _selectedDate = DateTime.parse(elder['birthdate']);
          tanggalLahirController.text =
              "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
        } catch (e) {
          debugPrint('Error parsing birthdate: $e');
        }
      }

      // Try both snake_case and camelCase field names for body height
      final bodyHeight = elder['body_height'] ?? elder['bodyHeight'];
      if (bodyHeight != null) {
        try {
          final double height = bodyHeight is num
              ? (bodyHeight as num).toDouble()
              : double.parse(bodyHeight.toString());
          tinggiController.text = height.round().toString();
          debugPrint('Successfully set height: ${tinggiController.text}');
        } catch (e) {
          debugPrint('Error parsing body height: $e');
          tinggiController.text = '';
        }
      } else {
        debugPrint('Body height field not found in data');
      }

      final bodyWeight = elder['body_weight'] ?? elder['bodyWeight'];
      if (bodyWeight != null) {
        try {
          final double weight = bodyWeight is num
              ? (bodyWeight as num).toDouble()
              : double.parse(bodyWeight.toString());
          beratController.text = weight.round().toString();
          debugPrint('Successfully set weight: ${beratController.text}');
        } catch (e) {
          debugPrint('Error parsing body weight: $e');
          beratController.text = '';
        }
      } else {
        debugPrint('Body weight field not found in data');
      }
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
      elderId: _isEditing ? _elderId! : Uuid().v4(),
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

    if (_isEditing) {
      context.read<ElderBloc>().add(UpdateElderEvent(_elderId!, elder));
    } else {
      context.read<ElderBloc>().add(CreateElderEvent(elder));
    }
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
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserSuccess) {
              setState(() => _isCheckingUser = false);

              if (state.response.data != null &&
                  state.response.data is Map &&
                  state.response.data.containsKey('elders')) {
                _populateFormWithElderData(state.response.data['elders']);
              }
            } else if (state is UserFailure) {
              setState(() => _isCheckingUser = false);
              ToastHelper.showErrorToast(context, state.error);
            }
          },
        ),
        BlocListener<ElderBloc, ElderState>(
          listener: (context, state) {
            if (state is ElderSuccess) {
              if (!widget.isFinalStep) {
                widget.onNext();
              }
            } else if (state is ElderFailure) {
              ToastHelper.showErrorToast(context, state.error);
            }
          },
        ),
      ],
      child: BlocBuilder<ElderBloc, ElderState>(
        builder: (context, elderState) {
          final bool isLoading = elderState is ElderLoading || _isCheckingUser;

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
                    hintText: 'Masukkan nama elder',
                    controller: namaController,
                    icon: Icons.person,
                    onChanged: (_) => _validateForm(),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Nama tidak boleh kosong'
                        : null,
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
