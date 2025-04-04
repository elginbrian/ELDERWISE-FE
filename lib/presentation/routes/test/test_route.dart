import 'package:elderwise/presentation/screens/test/test_agenda.dart';
import 'package:elderwise/presentation/screens/test/test_area.dart';
import 'package:elderwise/presentation/screens/test/test_auth.dart';
import 'package:elderwise/presentation/screens/test/test_caregiver.dart';
import 'package:elderwise/presentation/screens/test/test_elder.dart';
import 'package:elderwise/presentation/screens/test/test_emergency_alert.dart';
import 'package:elderwise/presentation/screens/test/test_home.dart';
import 'package:elderwise/presentation/screens/test/test_location_history.dart';
import 'package:elderwise/presentation/screens/test/test_user.dart';
import 'package:go_router/go_router.dart';

final GoRouter testRouter = GoRouter(
  initialLocation: '/testHome',
  routes: [
    GoRoute(
      path: '/testHome',
      builder: (context, state) => const HomeTest(),
    ),
    GoRoute(
      path: '/testAgenda',
      builder: (context, state) => const TestAgendaScreen(),
    ),
    GoRoute(
      path: '/testArea',
      builder: (context, state) => const TestAreaScreen(),
    ),
    GoRoute(
      path: '/testAuth',
      builder: (context, state) => const TestAuthScreen(),
    ),
    GoRoute(
      path: '/testCaregiver',
      builder: (context, state) => const TestCaregiverScreen(),
    ),
    GoRoute(
      path: '/testElder',
      builder: (context, state) => const TestElderScreen(),
    ),
    GoRoute(
      path: '/testEmergencyAlert',
      builder: (context, state) => const TestEmergencyAlertScreen(),
    ),
    GoRoute(
      path: '/testUser',
      builder: (context, state) => const TestUserScreen(),
    ),
    GoRoute(
      path: '/testLocationHistory',
      builder: (context, state) => const TestLocationHistoryScreen(),
    ),
  ],
);
