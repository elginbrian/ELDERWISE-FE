import 'package:elderwise/presentation/screens/agenda_screen/add_agenda.dart';
import 'package:elderwise/presentation/screens/agenda_screen/agenda_page.dart';
import 'package:elderwise/presentation/screens/auth_screen/login_screen.dart';
import 'package:elderwise/presentation/screens/auth_screen/onboarding.dart';
import 'package:elderwise/presentation/screens/auth_screen/profile_information/stepper.dart';
import 'package:elderwise/presentation/screens/auth_screen/signup_screen.dart';
import 'package:elderwise/presentation/screens/geofence_screen/geofence_screen.dart';
import 'package:elderwise/presentation/screens/main_screen/main_screen.dart';
import 'package:elderwise/presentation/screens/profile_screen/main_profile_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
        path: '/onboarding', builder: (context, state) => const  GeofenceScreen()),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
        path: '/fill-information',
        builder: (context, state) => const StepperScreen()),
    GoRoute(path: '/home', builder: (context, state) => const MainScreen()),
  ],
);
