import 'package:elderwise/presentation/screens/auth_screen/login_screen.dart';
import 'package:elderwise/presentation/screens/auth_screen/onboarding.dart';
import 'package:elderwise/presentation/screens/auth_screen/profile_information/stepper.dart';
import 'package:elderwise/presentation/screens/auth_screen/signup_screen.dart';
import 'package:elderwise/presentation/screens/geofence_screen/geofence_screen.dart';
import 'package:elderwise/presentation/screens/main_screen/main_screen.dart';
import 'package:elderwise/presentation/screens/profile_screen/main_profile_screen.dart';
import 'package:elderwise/presentation/screens/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter testRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => MainScreen(),
    ),
  ],
);
