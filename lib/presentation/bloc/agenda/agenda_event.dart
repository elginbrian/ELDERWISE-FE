import 'package:elderwise/data/api/requests/agenda_request.dart';

abstract class AgendaEvent {}

class GetAgendaEvent extends AgendaEvent {
  final String agendaId;
  GetAgendaEvent(this.agendaId);
}

class CreateAgendaEvent extends AgendaEvent {
  final AgendaRequestDTO agendaRequest;
  CreateAgendaEvent(this.agendaRequest);
}

class UpdateAgendaEvent extends AgendaEvent {
  final String agendaId;
  final AgendaRequestDTO agendaRequest;
  UpdateAgendaEvent(this.agendaId, this.agendaRequest);
}

class DeleteAgendaEvent extends AgendaEvent {
  final String agendaId;
  DeleteAgendaEvent(this.agendaId);
}
