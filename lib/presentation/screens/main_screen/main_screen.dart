import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/screens/geofence_screen/geofence_screen.dart';
import 'package:elderwise/presentation/screens/main_screen/homescreen.dart';
import 'package:elderwise/presentation/screens/profile_screen/main_profile_screen.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:elderwise/presentation/screens/agenda_screen/agenda_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static final GlobalKey<_MainScreenState> mainScreenKey =
      GlobalKey<_MainScreenState>();

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  void changeTab(int index) {
    if (index >= 0 && index < screens.length) {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.primaryMain,
          body: screens[selectedIndex],
        ),
        _navBar(),
      ],
    );
  }

  Widget _navBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 64,
        margin: const EdgeInsets.only(left: 32, right: 32, bottom: 24),
        decoration: BoxDecoration(
          color: AppColors.neutral10,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: AppColors.neutral20,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
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
                    Text(navTitles[index],
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 8,
                              color: selectedIndex == index
                                  ? AppColors.primaryMain
                                  : AppColors.neutral60,
                            )),
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

List<Widget> navIcons = [
  Icon(Icons.home_rounded, size: 24, color: AppColors.neutral60),
  Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.neutral60),
  Icon(Icons.map_rounded, size: 24, color: AppColors.neutral60),
  Icon(Icons.person_rounded, size: 24, color: AppColors.neutral60),
];

List<Widget> navIconsActive = [
  Icon(Icons.home_rounded, size: 24, color: AppColors.primaryMain),
  Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.primaryMain),
  Icon(Icons.map_rounded, size: 24, color: AppColors.primaryMain),
  Icon(Icons.person_rounded, size: 24, color: AppColors.primaryMain),
];

List<String> navTitles = [
  "Home",
  "Agenda",
  "Maps",
  "Profile",
];

class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.home, size: 64, color: AppColors.primaryMain),
            SizedBox(height: 16),
            Text(
              "Home Screen",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryMain,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Coming Soon",
              style: TextStyle(fontSize: 16, color: AppColors.neutral90),
            ),
          ],
        ),
      ),
    );
  }
}

class AgendaPlaceholderScreen extends StatelessWidget {
  const AgendaPlaceholderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.calendar_today, size: 64, color: AppColors.primaryMain),
            SizedBox(height: 16),
            Text(
              "Agenda Screen",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryMain,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Coming Soon",
              style: TextStyle(fontSize: 16, color: AppColors.neutral90),
            ),
          ],
        ),
      ),
    );
  }
}

final List<Widget> screens = [
  const Homescreen(),
  const AgendaPage(),
  const GeofenceScreen(),
  const MainProfileScreen(),
];
