import 'package:elderwise/domain/entities/agenda.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_bloc.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_event.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_state.dart';
import 'package:elderwise/presentation/bloc/auth/auth_bloc.dart';
import 'package:elderwise/presentation/bloc/auth/auth_event.dart';
import 'package:elderwise/presentation/bloc/auth/auth_state.dart';
import 'package:elderwise/presentation/bloc/user/user_bloc.dart';
import 'package:elderwise/presentation/bloc/user/user_event.dart';
import 'package:elderwise/presentation/bloc/user/user_state.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/screens/main_screen/main_screen.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/utils/toast_helper.dart';
import 'package:elderwise/presentation/widgets/homescreen/elder_agenda_section.dart';
import 'package:elderwise/presentation/widgets/homescreen/elder_greeting_section.dart';
import 'package:elderwise/presentation/widgets/homescreen/elder_profile_header.dart';
import 'package:elderwise/presentation/widgets/homescreen/sos_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomescreenElder extends StatefulWidget {
  const HomescreenElder({super.key});

  @override
  State<HomescreenElder> createState() => _HomescreenElderState();
}

class _HomescreenElderState extends State<HomescreenElder> {
  String _userId = '';
  String _elderId = '';
  bool _isLoading = true;
  bool _userDataLoaded = false;
  List<Agenda> _agendas = [];

  String _userName = "Elder";
  String? _elderPhotoUrl;
  dynamic _elderData;

  @override
  void initState() {
    super.initState();
    // Permintaan data saat inisialisasi
    context.read<AuthBloc>().add(GetCurrentUserEvent());
  }

  void _loadUserData() {
    if (_userId.isNotEmpty && !_userDataLoaded) {
      context.read<UserBloc>().add(GetUserEldersEvent(_userId));
      _userDataLoaded = true;
    }
  }

  void _loadAgendas() {
    if (_elderId.isNotEmpty) {
      context.read<AgendaBloc>().add(GetAgendasByElderIdEvent(_elderId));
    }
  }

  void _populateElderData(dynamic elderData) {
    if (elderData == null || elderData.isEmpty) return;

    final elder = elderData[0];
    setState(() {
      _elderData = elder;
      _elderId = elder['elder_id'] ?? elder['id'] ?? '';
      _userName = elder['name'] ?? "Elder";

      if (elder['photo_url'] != null) {
        _elderPhotoUrl = elder['photo_url'];
      }

      if (_elderId.isNotEmpty) {
        _loadAgendas();
      }
    });
  }

  void _navigateToNotifications() {
    Navigator.pushNamed(context, '/notifications');
  }

  void _activateSOS() {
    ToastHelper.showSuccessToast(context, "Panggilan SOS diaktifkan");
  }

  void _navigateToAgendaPage() {
    MainScreen.mainScreenKey.currentState?.changeTab(1);
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
              setState(() => _isLoading = false);

              if (state.response.data != null && state.response.data is Map) {
                if (state.response.data.containsKey('elders') &&
                    state.response.data['elders'] is List) {
                  _populateElderData(state.response.data['elders']);
                }
              }
            } else if (state is UserFailure) {
              setState(() => _isLoading = false);
              ToastHelper.showErrorToast(
                context,
                ToastHelper.getUserFriendlyErrorMessage(state.error),
              );
            }
          },
        ),
        BlocListener<AgendaBloc, AgendaState>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is AgendaLoading;
            });

            if (state is AgendaListSuccess) {
              setState(() {
                _agendas = state.agendas;
              });
            }
          },
        ),
      ],
      child: Stack(
        children: [
          Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(iconImages + 'bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  // Upper section
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElderProfileHeader(
                          elderPhotoUrl: _elderPhotoUrl,
                          onNotificationTap: _navigateToNotifications,
                        ),
                        ElderGreetingSection(userName: _userName),
                      ],
                    ),
                  ),

                  // Lower section (agenda)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppColors.secondarySurface,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32.0),
                          topRight: Radius.circular(32.0),
                        ),
                      ),
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElderAgendaSection(
                              agendas: _agendas,
                              onSeeAllTap: _navigateToAgendaPage,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SOS button overlay
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: SosButton(onTap: _activateSOS),
            ),
          ),
        ],
      ),
    );
  }
}
