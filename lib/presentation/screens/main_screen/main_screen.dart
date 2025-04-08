import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/screens/geofence_screen/geofence_screen.dart';
import 'package:elderwise/presentation/screens/profile_screen/main_profile_screen.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

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
        margin: const EdgeInsets.only(left: 18, right: 18, bottom: 24),
        decoration: BoxDecoration(
          color: AppColors.neutral10,
          borderRadius: BorderRadius.circular(32),
          // border: Border.all(color: AppColors.primaryMain)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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
                                  : AppColors.neutral90,
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

// Navigation bar icons and titles
List<Image> navIcons = [
  Image.asset('${iconImages}home.png', width: 20, height: 20),
  Image.asset('${iconImages}clock.png', width: 20, height: 20),
  Image.asset('${iconImages}map.png', width: 20, height: 20),
  Image.asset('${iconImages}profile.png', width: 20, height: 20),
];

List<Image> navIconsActive = [
  Image.asset('${iconImages}home_active.png', width: 20, height: 20),
  Image.asset('${iconImages}clock_active.png', width: 20, height: 20),
  Image.asset('${iconImages}map_active.png', width: 20, height: 20),
  Image.asset('${iconImages}profile_active.png', width: 20, height: 20),
];

List<String> navTitles = [
  "Home",
  "Agenda",
  "Maps",
  "Profile",
];

// Define placeholder screens for empty tabs
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

// Screens for each tab
final List<Widget> screens = [
  // Home tab (empty placeholder for now)
  const HomePlaceholderScreen(),
  // Agenda tab (empty placeholder for now)
  const AgendaPlaceholderScreen(),
  // Maps tab shows the geofence map
  const GeofenceScreen(),
  // Profile tab shows the main profile screen
  const MainProfileScreen(),
];
