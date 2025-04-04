import 'package:elderwise/presentation/screens/auth_screen/login_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter testRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
  ],
);
