import 'package:elderwise/domain/entities/agenda.dart';
import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_bloc.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_event.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_state.dart';
import 'package:elderwise/presentation/bloc/auth/auth_bloc.dart';
import 'package:elderwise/presentation/bloc/auth/auth_event.dart';
import 'package:elderwise/presentation/bloc/auth/auth_state.dart';
import 'package:elderwise/presentation/bloc/user/user_bloc.dart';
import 'package:elderwise/presentation/bloc/user/user_event.dart';
import 'package:elderwise/presentation/bloc/user/user_state.dart';
import 'package:elderwise/presentation/bloc/user_mode/user_mode_bloc.dart';
import 'package:elderwise/presentation/screens/agenda_screen/add_agenda.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/utils/toast_helper.dart';
import 'package:elderwise/presentation/widgets/agenda/date_header.dart';
import 'package:elderwise/presentation/widgets/agenda/week_selector.dart';
import 'package:elderwise/presentation/widgets/agenda/agenda_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController dateController = TextEditingController();
  late DateTime anchorDate;

  String _userId = '';
  String _elderId = '';
  String _caregiverId = '';
  bool _isLoading = false;
  bool _userDataLoaded = false;
  List<Agenda> _agendas = [];
  List<Agenda> _filteredAgendas = [];

  final List<String> weekdays = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];

  @override
  void initState() {
    super.initState();
    anchorDate =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    initializeDateFormatting('id_ID', null).then((_) {
      setState(() {
        dateController.text =
            DateFormat('yyyy-MM-dd', 'id_ID').format(selectedDate);
      });
    });

    context.read<UserModeBloc>().add(InitializeUserModeEvent());
    context.read<AuthBloc>().add(GetCurrentUserEvent());
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    if (_userId.isNotEmpty && !_userDataLoaded) {
      context.read<UserBloc>().add(GetUserEldersEvent(_userId));
      context.read<UserBloc>().add(GetUserCaregiversEvent(_userId));
      _userDataLoaded = true;
    }
  }

  void _loadAgendas() {
    if (_elderId.isNotEmpty) {
      context.read<AgendaBloc>().add(GetAgendasByElderIdEvent(_elderId));
    } else {
      ToastHelper.showErrorToast(context, 'ID Elder tidak ditemukan');
    }
  }

  void _filterAgendasByDate() {
    if (_agendas.isEmpty) return;

    setState(() {
      _filteredAgendas = _agendas.where((agenda) {
        final agendaDate = agenda.datetime;
        return agendaDate.year == selectedDate.year &&
            agendaDate.month == selectedDate.month &&
            agendaDate.day == selectedDate.day;
      }).toList();
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    _filterAgendasByDate();
  }

  List<DateTime> getDaysInWeek() {
    final DateTime weekStart =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    return List.generate(7, (index) => weekStart.add(Duration(days: index)));
  }

  void previousWeek() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 7));
    });
    _filterAgendasByDate();
  }

  void nextWeek() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 7));
    });
    _filterAgendasByDate();
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryMain,
              onPrimary: AppColors.neutral90,
              onSurface: AppColors.neutral90,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _selectDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userMode = context.select((UserModeBloc bloc) => bloc.state.userMode);
    final isElderMode = userMode == UserMode.elder;
    final daysInWeek = getDaysInWeek();

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

                  if (_elderId.isNotEmpty) {
                    _loadAgendas();
                  }
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
              ToastHelper.showSuccessToast(context, 'Operasi agenda berhasil');
              _loadAgendas();
            } else if (state is AgendaListSuccess) {
              setState(() {
                _agendas = state.agendas;
                _filterAgendasByDate();
              });
            } else if (state is AgendaFailure) {
              ToastHelper.showErrorToast(context, state.error);
            }
          },
        ),
        BlocListener<UserModeBloc, UserModeState>(
          listener: (context, state) {
            setState(() {});
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
                        horizontal: 16.0, vertical: 24.0),
                    child: Row(
                      children: [
                        const Text(
                          'Agenda',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: AppColors.neutral90,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      decoration: const BoxDecoration(
                        color: AppColors.secondarySurface,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DateHeader(
                            selectedDate: selectedDate,
                            onTap: _showDatePicker,
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: WeekSelector(
                              daysInWeek: daysInWeek,
                              selectedDate: selectedDate,
                              weekdays: weekdays,
                              onDateSelected: _selectDate,
                              onPreviousWeek: previousWeek,
                              onNextWeek: nextWeek,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Agenda Kegiatan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                  color: AppColors.neutral90,
                                ),
                              ),
                              Text(
                                DateFormat('d MMMM', 'id_ID')
                                    .format(selectedDate),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  color: AppColors.neutral70,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: AgendaList(
                              agendas: _filteredAgendas,
                              isLoading: _isLoading,
                              onAgendaUpdated: _loadAgendas,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (!isElderMode)
                Positioned(
                  right: 16,
                  bottom:
                      32,
                  child: FloatingActionButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddAgenda()),
                      );
                      if (result == true) {
                        _loadAgendas();
                      }
                    },
                    elevation: 2,
                    backgroundColor: AppColors.primaryMain,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(Icons.add, color: AppColors.neutral90),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
