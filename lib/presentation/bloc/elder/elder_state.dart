import 'package:elderwise/data/api/responses/agenda_response.dart';
import 'package:elderwise/data/api/responses/area_response.dart';
import 'package:elderwise/data/api/responses/elder_response.dart';
import 'package:elderwise/data/api/responses/emergency_alert_response.dart';
import 'package:elderwise/data/api/responses/location_history_response.dart';

abstract class ElderState {}

class ElderInitial extends ElderState {}

class ElderLoading extends ElderState {}

class ElderSuccess extends ElderState {
  final ElderResponseDTO elder;
  ElderSuccess(this.elder);
}

class EldersSuccess extends ElderState {
  final EldersResponseDTO elders;
  EldersSuccess(this.elders);
}

class AreaSuccess extends ElderState {
  final AreaResponseDTO area;
  AreaSuccess(this.area);
}

class AreasSuccess extends ElderState {
  final AreasResponseDTO areas;
  AreasSuccess(this.areas);
}

class AgendasSuccess extends ElderState {
  final AgendasResponseDTO agendas;
  AgendasSuccess(this.agendas);
}

class AgendaSuccess extends ElderState {
  final AgendaResponseDTO agenda;
  AgendaSuccess(this.agenda);
}

class EmergencyAlertSuccess extends ElderState {
  final EmergencyAlertResponseDTO response;
  EmergencyAlertSuccess(this.response);
}

class LocationHistorySuccess extends ElderState {
  final LocationHistoryResponseDTO response;
  LocationHistorySuccess(this.response);
}

class LocationHistoryPointsSuccess extends ElderState {
  final LocationHistoryPointsResponseDTO response;
  LocationHistoryPointsSuccess(this.response);
}

class ElderFailure extends ElderState {
  final String error;
  ElderFailure(this.error);
}
