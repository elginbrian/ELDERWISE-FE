import 'package:dio/dio.dart';
import 'package:elderwise/data/api/api_config.dart';
import 'package:elderwise/data/repositories/agenda_repository_impl.dart';
import 'package:elderwise/data/repositories/area_repository_impl.dart';
import 'package:elderwise/data/repositories/auth_repository_impl.dart';
import 'package:elderwise/data/repositories/caregiver_repository_impl.dart';
import 'package:elderwise/data/repositories/elder_repository_impl.dart';
import 'package:elderwise/data/repositories/emergency_alert_repository_impl.dart';
import 'package:elderwise/data/repositories/image_repository_impl.dart';
import 'package:elderwise/data/repositories/location_history_repository_impl.dart';
import 'package:elderwise/data/repositories/user_repository_impl.dart';
import 'package:elderwise/domain/repositories/agenda_repository.dart';
import 'package:elderwise/domain/repositories/area_repository.dart';
import 'package:elderwise/domain/repositories/auth_repository.dart';
import 'package:elderwise/domain/repositories/caregiver_repository.dart';
import 'package:elderwise/domain/repositories/elder_repository.dart';
import 'package:elderwise/domain/repositories/emergency_alert_repository.dart';
import 'package:elderwise/domain/repositories/image_repository.dart';
import 'package:elderwise/domain/repositories/location_history_repository.dart';
import 'package:elderwise/domain/repositories/user_repository.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_bloc.dart';
import 'package:elderwise/presentation/bloc/area/area_bloc.dart';
import 'package:elderwise/presentation/bloc/auth/auth_bloc.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_bloc.dart';
import 'package:elderwise/presentation/bloc/elder/elder_bloc.dart';
import 'package:elderwise/presentation/bloc/emergency_alert/emergency_alert_bloc.dart';
import 'package:elderwise/presentation/bloc/image/image_bloc.dart';
import 'package:elderwise/presentation/bloc/location_history/location_history_bloc.dart';
import 'package:elderwise/presentation/bloc/user/user_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<Dio>(() => ApiConfig.dio);

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<AgendaRepository>(
    () => AgendaRepositoryImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<AreaRepository>(
    () => AreaRepositoryImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<CaregiverRepository>(
    () => CaregiverRepositoryImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<ElderRepository>(
    () => ElderRepositoryImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<EmergencyAlertRepository>(
    () => EmergencyAlertRepositoryImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<LocationHistoryRepository>(
    () => LocationHistoryRepositoryImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<ImageRepository>(
    () => ImageRepositoryImpl(),
  );

  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));
  getIt
      .registerFactory<AgendaBloc>(() => AgendaBloc(getIt<AgendaRepository>()));
  getIt.registerFactory<AreaBloc>(() => AreaBloc(getIt<AreaRepository>()));
  getIt.registerFactory<CaregiverBloc>(
      () => CaregiverBloc(getIt<CaregiverRepository>()));
  getIt.registerFactory<ElderBloc>(() => ElderBloc(getIt<ElderRepository>()));
  getIt.registerFactory<EmergencyAlertBloc>(
      () => EmergencyAlertBloc(getIt<EmergencyAlertRepository>()));
  getIt.registerFactory<LocationHistoryBloc>(
      () => LocationHistoryBloc(getIt<LocationHistoryRepository>()));
  getIt.registerFactory<UserBloc>(() => UserBloc(getIt<UserRepository>()));
  getIt.registerFactory<ImageBloc>(() => ImageBloc(getIt<ImageRepository>()));
}
