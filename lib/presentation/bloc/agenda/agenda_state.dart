import 'package:elderwise/data/api/responses/agenda_response.dart';
import 'package:elderwise/domain/entities/agenda.dart';

abstract class AgendaState {}

class AgendaInitial extends AgendaState {}

class AgendaLoading extends AgendaState {}

class AgendasSuccess extends AgendaState {
  final AgendasResponseDTO agendas;
  AgendasSuccess(this.agendas);

  List<Agenda> get agendasList => agendas.agendas;

  Agenda getAgendaById(String id) =>
      agendas.agendas.firstWhere((agenda) => agenda.agendaId == id);
  Agenda getAgendaByCaregiverId(String id) =>
      agendas.agendas.firstWhere((agenda) => agenda.caregiverId == id);
  Agenda getAgendaByElderId(String id) =>
      agendas.agendas.firstWhere((agenda) => agenda.elderId == id);
  Agenda getAgendaByCategory(String category) =>
      agendas.agendas.firstWhere((agenda) => agenda.category == category);
}

class AgendaSuccess extends AgendaState {
  final AgendaResponseDTO agenda;
  AgendaSuccess(this.agenda);

  Agenda get agendaItem => agenda.agenda;
}

class AgendaFailure extends AgendaState {
  final String error;
  AgendaFailure(this.error);
}
