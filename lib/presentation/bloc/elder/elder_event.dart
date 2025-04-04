import 'package:elderwise/domain/entities/elder.dart';

abstract class ElderEvent {}

class GetElderEvent extends ElderEvent {
  final String elderId;
  GetElderEvent(this.elderId);
}

class CreateElderEvent extends ElderEvent {
  final Elder elder;
  CreateElderEvent(this.elder);
}

class UpdateElderEvent extends ElderEvent {
  final String elderId;
  final Elder elder;
  UpdateElderEvent(this.elderId, this.elder);
}

class GetElderAreasEvent extends ElderEvent {
  final String elderId;
  GetElderAreasEvent(this.elderId);
}

class GetElderLocationHistoryEvent extends ElderEvent {
  final String elderId;
  GetElderLocationHistoryEvent(this.elderId);
}

class GetElderAgendasEvent extends ElderEvent {
  final String elderId;
  GetElderAgendasEvent(this.elderId);
}

class GetElderEmergencyAlertsEvent extends ElderEvent {
  final String elderId;
  GetElderEmergencyAlertsEvent(this.elderId);
}
