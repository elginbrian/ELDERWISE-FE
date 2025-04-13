import 'package:elderwise/presentation/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:elderwise/presentation/bloc/user_mode/user_mode_bloc.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/screens/geofence_screen/geofence_screen.dart';
import 'package:elderwise/presentation/screens/main_screen/homescreen.dart';
import 'package:elderwise/presentation/screens/main_screen/homescreen_elder.dart';
import 'package:elderwise/presentation/screens/profile_screen/main_profile_screen.dart';
import 'package:elderwise/presentation/screens/reminder_sceen/reminder_screen.dart';
import 'package:elderwise/presentation/screens/agenda_screen/agenda_page.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elderwise/services/fall_detection_service.dart';
import 'package:elderwise/presentation/widgets/homescreen/sos_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static final GlobalKey<_MainScreenState> mainScreenKey =
      GlobalKey<_MainScreenState>();

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userModeState = context.read<UserModeBloc>().state;
      FallDetectionService().startMonitoring(
        onFallDetected: _handleFallDetection,
        userMode: userModeState.userMode,
        startSosCountdown: () {
          if (SosButton.globalKey.currentState != null) {
            SosButton.globalKey.currentState!.startCountdown();
          } else {
            _handleFallDetection();
          }
        },
      );
    });
  }

  void _handleFallDetection() {
    ToastHelper.showSuccessToast(context, "Jatuh terdeteksi! Mengirim SOS...");

  }

  void changeTab(int index) {
    if (index >= 0) {
      setState(() {
        selectedIndex = index;

        final isElderMode =
            context.read<UserModeBloc>().state.userMode == UserMode.elder;
        final maxIndex =
            isElderMode ? elderScreens.length : regularScreens.length;

        if (selectedIndex >= maxIndex) {
          selectedIndex = 0;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserModeBloc, UserModeState>(
      builder: (context, state) {
        final isElderMode = state.userMode == UserMode.elder;
        final screens = isElderMode ? elderScreens : regularScreens;

        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.primaryMain,
              body:
                  screens[selectedIndex >= screens.length ? 0 : selectedIndex],
            ),
            _navBar(isElderMode),
          ],
        );
      },
    );
  }

  Widget _navBar(bool isElderMode) {
    final navIcons = isElderMode ? elderNavIcons : regularNavIcons;
    final navIconsActive =
        isElderMode ? elderNavIconsActive : regularNavIconsActive;
    final navTitles = isElderMode ? elderNavTitles : regularNavTitles;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 64,
        margin: EdgeInsets.only(
            left: isElderMode ? 64 : 32,
            right: isElderMode ? 64 : 32,
            bottom: 24),
        decoration: BoxDecoration(
          color: AppColors.neutral10,
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
              color: AppColors.neutral100.withOpacity(0.05),
            )
          ],
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: AppColors.neutral20,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(navIcons.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    selectedIndex == index
                        ? navIconsActive[index]
                        : navIcons[index],
                    const SizedBox(height: 4),
                    Text(
                      navTitles[index],
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 8,
                            color: selectedIndex == index
                                ? AppColors.primaryMain
                                : AppColors.neutral60,
                          ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

final List<Widget> regularScreens = [
  const Homescreen(),
  const AgendaPage(),
  const GeofenceScreen(),
  const MainProfileScreen(),
];

final List<Widget> regularNavIcons = [
  Icon(Icons.home_rounded, size: 24, color: AppColors.neutral60),
  Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.neutral60),
  Icon(Icons.map_rounded, size: 24, color: AppColors.neutral60),
  Icon(Icons.person_rounded, size: 24, color: AppColors.neutral60),
];

final List<Widget> regularNavIconsActive = [
  Icon(Icons.home_rounded, size: 24, color: AppColors.primaryMain),
  Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.primaryMain),
  Icon(Icons.map_rounded, size: 24, color: AppColors.primaryMain),
  Icon(Icons.person_rounded, size: 24, color: AppColors.primaryMain),
];

final List<String> regularNavTitles = [
  "Home",
  "Agenda",
  "Maps",
  "Profile",
];

final List<Widget> elderScreens = [
  const HomescreenElder(),
  const AgendaPage(),
  const MainProfileScreen(),
];

final List<Widget> elderNavIcons = [
  Icon(Icons.home_rounded, size: 24, color: AppColors.neutral60),
  Icon(Icons.map_rounded, size: 24, color: AppColors.neutral60),
  Icon(Icons.person_rounded, size: 24, color: AppColors.neutral60),
];

final List<Widget> elderNavIconsActive = [
  Icon(Icons.home_rounded, size: 24, color: AppColors.primaryMain),
  Icon(Icons.map_rounded, size: 24, color: AppColors.primaryMain),
  Icon(Icons.person_rounded, size: 24, color: AppColors.primaryMain),
];

final List<String> elderNavTitles = [
  "Home",
  "Agenda",
  "Profile",
];
