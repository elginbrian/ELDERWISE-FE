import 'package:elderwise/data/api/requests/emergency_alert_request.dart';
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
import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:elderwise/services/fall_detection_service.dart';
import 'package:elderwise/presentation/bloc/emergency_alert/emergency_alert_bloc.dart';
import 'package:elderwise/presentation/bloc/emergency_alert/emergency_alert_event.dart';
import 'package:elderwise/presentation/bloc/emergency_alert/emergency_alert_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_bloc.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_event.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_state.dart';
import 'package:elderwise/presentation/screens/notification_screen/notification_screen.dart';

class HomescreenElder extends StatefulWidget {
  const HomescreenElder({super.key});

  @override
  State<HomescreenElder> createState() => _HomescreenElderState();
}

class _HomescreenElderState extends State<HomescreenElder> {
  String _userId = '';
  String _elderId = '';
  String _caregiverId = '';
  bool _isLoading = true;
  bool _userDataLoaded = false;
  List<Agenda> _agendas = [];

  String _userName = "Elder";
  String? _elderPhotoUrl;
  dynamic _elderData;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetCurrentUserEvent());

    FallDetectionService().startMonitoring(
      onFallDetected: _handleFallDetection,
      userMode: UserMode.elder,
      startSosCountdown: () {
        if (SosButton.globalKey.currentState != null) {
          SosButton.globalKey.currentState!.startCountdown();
        } else {
          _activateSOS();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
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

  void _loadCaregiverData() {
    if (_elderId.isNotEmpty) {
      context.read<CaregiverBloc>().add(GetCaregiverEvent(_elderId));
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
        _loadCaregiverData();
      }
    });
  }

  void _navigateToNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationScreen(),
      ),
    );
  }

  void _activateSOS() {
    _sendEmergencyAlert(false);
  }

  void _handleFallDetection() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendEmergencyAlert(true);
    });
  }

  Future<void> _sendEmergencyAlert(bool isFallDetection) async {
    try {
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } catch (e) {
        debugPrint('Could not get location: $e');
      }

      final currentDateTime = DateTime.now().toUtc();

      final alertRequest = EmergencyAlertRequestDTO(
        elderId: _elderId,
        caregiverId: _caregiverId.isNotEmpty ? _caregiverId : _userId,
        datetime: currentDateTime,
        elderLat: position?.latitude ?? 0.0,
        elderLong: position?.longitude ?? 0.0,
        isDismissed: false,
      );

      context.read<EmergencyAlertBloc>().add(
            CreateEmergencyAlertEvent(alertRequest),
          );

      ToastHelper.showSuccessToast(
        context,
        isFallDetection
            ? "Fall detected! Sending emergency alert..."
            : "Emergency alert activated",
      );
    } catch (e) {
      ToastHelper.showErrorToast(context, "Failed to send emergency alert: $e");
    }
  }

  void _navigateToAgendaPage() {
    MainScreen.mainScreenKey.currentState?.changeTab(1);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final topPadding = mediaQuery.padding.top;
    final bottomInset = mediaQuery.viewInsets.bottom;
    final availableHeight = screenHeight - topPadding - bottomInset;

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
        BlocListener<EmergencyAlertBloc, EmergencyAlertState>(
          listener: (context, state) {
            if (state is EmergencyAlertLoading) {
            } else if (state is EmergencyAlertSuccess) {
              ToastHelper.showSuccessToast(
                context,
                "Emergency alert sent successfully. Help is on the way!",
              );
            } else if (state is EmergencyAlertFailure) {
              ToastHelper.showErrorToast(
                context,
                "Failed to send emergency alert: ${state.error}",
              );
            }
          },
        ),
        BlocListener<CaregiverBloc, CaregiverState>(
          listener: (context, state) {
            if (state is CaregiverSuccess) {
              setState(() {
                _caregiverId = state.caregiver.caregiver.caregiverId;
              });
              debugPrint('Caregiver ID set: $_caregiverId');
            } else if (state is CaregiverFailure) {
              debugPrint('Failed to fetch caregiver: ${state.error}');
            }
          },
        ),
      ],
      child: SafeArea(
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElderProfileHeader(
                            elderPhotoUrl: _elderPhotoUrl,
                            onNotificationTap: _navigateToNotifications,
                            showNotifications:
                                true, // Add this parameter to ensure notification icon is visible
                          ),
                          const SizedBox(height: 16),
                          ElderGreetingSection(userName: _userName),
                          SizedBox(height: screenHeight * 0.09),
                        ],
                      ),
                    ),
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
            Positioned(
              top: screenHeight * 0.2,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: SosButton(
                  key: SosButton.globalKey,
                  onTap: _activateSOS,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
