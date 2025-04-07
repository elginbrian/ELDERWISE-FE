import 'package:dio/dio.dart';
import 'package:elderwise/data/api/env_config.dart';
import 'package:elderwise/data/api/interceptor.dart';

class ApiConfig {
  static String get currentEnv => appConfig.environment;

  static String get baseUrl => appConfig.apiBaseUrl;

  static Dio get dio {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(TokenInterceptor(dio: dio));

    if (currentEnv == 'development') {
      dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }

    return dio;
  }

  static String register = "/auth/register";
  static String login = "/auth/login";
  static String getCurrentUser = "/auth/me";

  static String getUser(String userId) => "/users/$userId";
  static String getUserCaregivers(String userId) => "/users/$userId/caregivers";
  static String getUserElders(String userId) => "/users/$userId/elders";

  static String getCaregiver(String caregiverId) => "/caregivers/$caregiverId";
  static String createCaregiver = "/caregivers";
  static String updateCaregiver(String caregiverId) =>
      "/caregivers/$caregiverId";

  static String getElder(String elderId) => "/elders/$elderId";
  static String createElder = "/elders";
  static String updateElder(String elderId) => "/elders/$elderId";
  static String getElderAreas(String elderId) => "/elders/$elderId/areas";
  static String getElderLocationHistory(String elderId) =>
      "/elders/$elderId/location-history";
  static String getElderAgendas(String elderId) => "/elders/$elderId/agendas";
  static String getElderEmergencyAlerts(String elderId) =>
      "/elders/$elderId/emergency-alerts";

  static String getArea(String areaId) => "/areas/$areaId";
  static String createArea = "/areas";
  static String updateArea(String areaId) => "/areas/$areaId";
  static String deleteArea(String areaId) => "/areas/$areaId";
  static String getCaregiverAreas(String caregiverId) =>
      "/caregivers/$caregiverId/areas";

  static String getLocationHistory(String locationHistoryId) =>
      "/location-history/$locationHistoryId";
  static String getLocationHistoryPoints(String locationHistoryId) =>
      "/location-history/$locationHistoryId/points";

  static String getAgenda(String agendaId) => "/agendas/$agendaId";
  static String createAgenda = "/agendas";
  static String updateAgenda(String agendaId) => "/agendas/$agendaId";
  static String deleteAgenda(String agendaId) => "/agendas/$agendaId";

  static String getEmergencyAlert(String alertId) =>
      "/emergency-alerts/$alertId";
  static String createEmergencyAlert = "/emergency-alerts";
  static String updateEmergencyAlert(String alertId) =>
      "/emergency-alerts/$alertId";

  static String processEntityImage = "/storage/images";
}
