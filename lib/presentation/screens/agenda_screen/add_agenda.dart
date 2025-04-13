import 'package:elderwise/data/api/requests/agenda_request.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_bloc.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_event.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_state.dart';
import 'package:elderwise/presentation/bloc/auth/auth_bloc.dart';
import 'package:elderwise/presentation/bloc/auth/auth_event.dart';
import 'package:elderwise/presentation/bloc/auth/auth_state.dart';
import 'package:elderwise/presentation/bloc/user/user_bloc.dart';
import 'package:elderwise/presentation/bloc/user/user_event.dart';
import 'package:elderwise/presentation/bloc/user/user_state.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/utils/toast_helper.dart';
import 'package:elderwise/presentation/widgets/agenda/agenda_selector.dart';
import 'package:elderwise/presentation/widgets/agenda/agenda_form_section.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAgenda extends StatefulWidget {
  final String? agendaId;
  final String? category;
  final String? content1;
  final String? content2;
  final String? timeStr;

  const AddAgenda({
    super.key,
    this.agendaId,
    this.category,
    this.content1,
    this.content2,
    this.timeStr,
  });

  @override
  State<AddAgenda> createState() => _AddAgendaState();
}

class _AddAgendaState extends State<AddAgenda> {
  String? selectedAgenda;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TimeOfDay? _selectedTime;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  String _userId = '';
  String _elderId = '';
  String _caregiverId = '';
  bool _userDataLoaded = false;

  @override
  void initState() {
    super.initState();
    selectedAgenda = widget.category ?? "Obat";
    _nameController = TextEditingController(text: widget.content1 ?? '');
    _amountController = TextEditingController(text: widget.content2 ?? '');

    if (widget.timeStr != null) {
      final timeParts = widget.timeStr!.split(':');
      if (timeParts.length == 2) {
        _selectedTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }
    } else {
      _selectedTime = null;
    }

    if (widget.agendaId != null && widget.timeStr != null) {
      _selectedDate = DateTime.now();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(GetCurrentUserEvent());
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onTimeSelected(TimeOfDay time) {
    _selectedTime = time;
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _loadUserData() {
    if (_userId.isNotEmpty && !_userDataLoaded) {
      context.read<UserBloc>().add(GetUserEldersEvent(_userId));
      context.read<UserBloc>().add(GetUserCaregiversEvent(_userId));
      _userDataLoaded = true;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedTime != null) {
      if (_elderId.isEmpty) {
        ToastHelper.showErrorToast(context, 'ID Elder tidak ditemukan');
        return;
      }
      if (_caregiverId.isEmpty) {
        ToastHelper.showErrorToast(context, 'ID Caregiver tidak ditemukan');
        return;
      }

      final datetime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final utcDatetime = datetime.toUtc();
      final formattedDatetime = utcDatetime.toIso8601String();

      final agendaRequest = AgendaRequestDTO(
        elderId: _elderId,
        caregiverId: _caregiverId,
        category: selectedAgenda ?? 'Aktivitas',
        content1: _nameController.text.trim(),
        content2: _amountController.text.trim(),
        datetime: formattedDatetime,
        isFinished: false,
      );

      if (widget.agendaId != null) {
        context
            .read<AgendaBloc>()
            .add(UpdateAgendaEvent(widget.agendaId!, agendaRequest));
      } else {
        context.read<AgendaBloc>().add(CreateAgendaEvent(agendaRequest));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi formulir dengan benar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is CurrentUserSuccess) {
              setState(() {
                _userId = state.user.user.userId;
              });
              _loadUserData();
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserSuccess) {
              if (state.response.data != null && state.response.data is Map) {
                if (state.response.data.containsKey('elders') &&
                    state.response.data['elders'] is List &&
                    state.response.data['elders'].isNotEmpty) {
                  final elderData = state.response.data['elders'][0];
                  setState(() {
                    _elderId = elderData['elder_id'] ?? elderData['id'] ?? '';
                  });
                }

                if (state.response.data.containsKey('caregivers') &&
                    state.response.data['caregivers'] is List &&
                    state.response.data['caregivers'].isNotEmpty) {
                  final caregiverData = state.response.data['caregivers'][0];
                  setState(() {
                    _caregiverId = caregiverData['caregiver_id'] ??
                        caregiverData['id'] ??
                        '';
                  });
                }
              }
            } else if (state is UserFailure) {
              ToastHelper.showErrorToast(context, state.error);
            }
          },
        ),
        BlocListener<AgendaBloc, AgendaState>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is AgendaLoading;
            });

            if (state is AgendaSuccess) {
              ToastHelper.showSuccessToast(
                  context,
                  widget.agendaId != null
                      ? 'Agenda berhasil diperbarui'
                      : 'Agenda berhasil ditambahkan');
              Navigator.pop(context, true);
            } else if (state is AgendaFailure) {
              ToastHelper.showErrorToast(context, state.error);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.primaryMain,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios,
                              color: AppColors.neutral90),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          widget.agendaId != null
                              ? "Edit Agenda"
                              : "Tambah Agenda",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: AppColors.neutral90,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: const BoxDecoration(
                        color: AppColors.secondarySurface,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 32.0,
                                    left: 16.0,
                                    right: 16.0,
                                    bottom: 16.0,
                                  ),
                                  child: Column(
                                    children: [
                                      AgendaTypeDropdown(
                                        selectedValue: selectedAgenda,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedAgenda = value;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      if (selectedAgenda != null)
                                        AgendaFormSection(
                                          type: selectedAgenda!,
                                          nameController: _nameController,
                                          amountController: _amountController,
                                          selectedDate: _selectedDate,
                                          selectedTime: _selectedTime,
                                          onDateSelected: _onDateSelected,
                                          onTimeSelected: _onTimeSelected,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: MainButton(
                                buttonText: widget.agendaId != null
                                    ? "Perbarui Agenda"
                                    : "Tambah Agenda",
                                onTap: _isLoading ? () {} : _submitForm,
                                isLoading: _isLoading,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
