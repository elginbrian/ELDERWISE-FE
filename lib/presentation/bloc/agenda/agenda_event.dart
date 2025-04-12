import 'package:elderwise/data/api/requests/agenda_request.dart';
import 'package:equatable/equatable.dart';

abstract class AgendaEvent extends Equatable {
  const AgendaEvent();

  @override
  List<Object> get props => [];
}

class GetAgendaEvent extends AgendaEvent {
  final String agendaId;

  const GetAgendaEvent(this.agendaId);

  @override
  List<Object> get props => [agendaId];
}

class GetAgendasByElderIdEvent extends AgendaEvent {
  final String elderId;

  const GetAgendasByElderIdEvent(this.elderId);

  @override
  List<Object> get props => [elderId];
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
