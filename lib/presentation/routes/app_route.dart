import 'package:elderwise/presentation/screens/agenda_screen/agenda_page.dart';
import 'package:elderwise/presentation/screens/auth_screen/login_screen.dart';
import 'package:elderwise/presentation/screens/auth_screen/mode_screen.dart';
import 'package:elderwise/presentation/screens/auth_screen/onboarding.dart';
import 'package:elderwise/presentation/screens/auth_screen/profile_information/stepper.dart';
import 'package:elderwise/presentation/screens/auth_screen/signup_screen.dart';
import 'package:elderwise/presentation/screens/geofence_screen/geofence_screen.dart';
import 'package:elderwise/presentation/screens/main_screen/main_screen.dart';
import 'package:elderwise/presentation/screens/notification_screen/empty_notification.dart';
import 'package:elderwise/presentation/screens/notification_screen/notification_screen.dart';
import 'package:elderwise/presentation/screens/profile_screen/profile_screen.dart';
import 'package:elderwise/presentation/screens/geofence_screen/set_fence_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:elderwise/data/api/interceptor.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  navigatorKey: navigatorKey,
  redirect: _guardRoutes,
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
    GoRoute(
        path: '/home',
        builder: (context, state) => MainScreen(key: MainScreen.mainScreenKey)),
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
    GoRoute(
      path: '/mode',
      builder: (context, state) => const ModeScreen(),
    ),
  ],
);

final _publicRoutes = [
  '/onboarding',
  '/login',
  '/signup',
];

Future<String?> _guardRoutes(BuildContext context, GoRouterState state) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final isAuthenticated = token != null && token.isNotEmpty;

  if (isAuthenticated && _publicRoutes.contains(state.matchedLocation)) {
    return '/home';
  }

  final isPublicRoute = _publicRoutes.contains(state.matchedLocation);
  if (!isPublicRoute && !isAuthenticated) {
    return '/login';
  }

  return null;
}
