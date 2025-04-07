import 'package:elderwise/data/api/env_config.dart';
import 'package:elderwise/presentation/widgets/web_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elderwise/di/container.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_bloc.dart';
import 'package:elderwise/presentation/bloc/auth/auth_bloc.dart';
import 'package:elderwise/presentation/bloc/area/area_bloc.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_bloc.dart';
import 'package:elderwise/presentation/bloc/elder/elder_bloc.dart';
import 'package:elderwise/presentation/bloc/emergency_alert/emergency_alert_bloc.dart';
import 'package:elderwise/presentation/bloc/image/image_bloc.dart';
import 'package:elderwise/presentation/bloc/location_history/location_history_bloc.dart';
import 'package:elderwise/presentation/bloc/user/user_bloc.dart';
import 'package:elderwise/presentation/routes/app_route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await appConfig.initialize();

  try {
    await Supabase.initialize(
      url: appConfig.supabaseUrl,
      anonKey: appConfig.supabaseAnonKey,
      debug: appConfig.environment == 'development',
    );
    debugPrint("Supabase initialized successfully");
  } catch (e, stackTrace) {
    debugPrint("Error initializing Supabase: $e");
    debugPrint(stackTrace.toString());
  }

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
        BlocProvider<ImageBloc>(create: (context) => getIt<ImageBloc>()),
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
      title: 'Elderwise',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
      builder: (context, child) {
        if (kIsWeb) {
          return WebLayout(
            localBackgroundImagePath:
                'lib/presentation/screens/assets/images/web_background.jpg',
            child: child ?? const SizedBox(),
          );
        }
        return child ?? const SizedBox();
      },
    );
  }
}
