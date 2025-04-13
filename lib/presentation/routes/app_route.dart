import 'package:elderwise/presentation/screens/agenda_screen/agenda_page.dart';
import 'package:elderwise/presentation/screens/auth_screen/login_screen.dart';
import 'package:elderwise/presentation/screens/auth_screen/mode_screen.dart';
import 'package:elderwise/presentation/screens/auth_screen/onboarding.dart';
import 'package:elderwise/presentation/screens/auth_screen/profile_information/stepper.dart';
import 'package:elderwise/presentation/screens/auth_screen/signup_screen.dart';
import 'package:elderwise/presentation/screens/geofence_screen/geofence_screen.dart';
import 'package:elderwise/presentation/screens/main_screen/homescreen.dart';
import 'package:elderwise/presentation/screens/main_screen/main_screen.dart';
import 'package:elderwise/presentation/screens/notification_screen/empty_notification.dart';
import 'package:elderwise/presentation/screens/notification_screen/notification_screen.dart';
import 'package:elderwise/presentation/screens/profile_screen/profile_screen.dart';
import 'package:elderwise/presentation/screens/geofence_screen/set_fence_screen.dart';
import 'package:elderwise/presentation/screens/reminder_sceen/crossing_screen.dart';
import 'package:elderwise/presentation/screens/reminder_sceen/crossing_screen_caregiver.dart';
import 'package:elderwise/presentation/screens/reminder_sceen/fall_screen.dart';
import 'package:elderwise/presentation/screens/reminder_sceen/sos_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
        path: '/onboarding', builder: (context, state) => const Onboarding()),
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
    GoRoute(path: '/home', builder: (context, state) => const Homescreen()),
    GoRoute(
        path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(
        path: '/geofence', builder: (context, state) => const GeofenceScreen()),
    GoRoute(
        path: '/set-fence',
        builder: (context, state) => const SetFenceScreen()),
    GoRoute(
      path: '/notification',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(path: '/agenda', builder: (context, state) => const AgendaPage()),
  ],
);
