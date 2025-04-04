import 'package:elderwise/data/api/app_config.dart';
import 'package:elderwise/presentation/widgets/web_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:elderwise/presentation/screens/auth_screen/login_screen.dart';
import 'package:elderwise/presentation/screens/main_screen/main_screen.dart';
import 'package:elderwise/presentation/themes/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elderwise/di/container.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_bloc.dart';
import 'package:elderwise/presentation/bloc/auth/auth_bloc.dart';
import 'package:elderwise/presentation/bloc/area/area_bloc.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_bloc.dart';
import 'package:elderwise/presentation/bloc/elder/elder_bloc.dart';
import 'package:elderwise/presentation/bloc/emergency_alert/emergency_alert_bloc.dart';
import 'package:elderwise/presentation/bloc/location_history/location_history_bloc.dart';
import 'package:elderwise/presentation/bloc/user/user_bloc.dart';
import 'package:elderwise/presentation/routes/test/test_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await appConfig.initialize();

  try {
    setupDependencies();
    debugPrint("Dependencies initialized successfully");
  } catch (e, stackTrace) {
    debugPrint("Error setting up dependencies: $e");
    debugPrint(stackTrace.toString());
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AgendaBloc>(create: (context) => getIt<AgendaBloc>()),
        BlocProvider<AuthBloc>(create: (context) => getIt<AuthBloc>()),
        BlocProvider<AreaBloc>(create: (context) => getIt<AreaBloc>()),
        BlocProvider<CaregiverBloc>(
            create: (context) => getIt<CaregiverBloc>()),
        BlocProvider<ElderBloc>(create: (context) => getIt<ElderBloc>()),
        BlocProvider<EmergencyAlertBloc>(
            create: (context) => getIt<EmergencyAlertBloc>()),
        BlocProvider<LocationHistoryBloc>(
            create: (context) => getIt<LocationHistoryBloc>()),
        BlocProvider<UserBloc>(create: (context) => getIt<UserBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Elderwise Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: testRouter,
      builder: (context, child) {
        if (kIsWeb) {
          return WebLayout(
            localBackgroundImagePath: 'assets/default_background.jpg',
            child: child ?? const SizedBox(),
          );
        }
        return child ?? const SizedBox();
      },
    );
  }
}
