import 'package:elderwise/data/api/responses/agenda_response.dart';
import 'package:elderwise/domain/entities/agenda.dart';
import 'package:equatable/equatable.dart';

abstract class AgendaState extends Equatable {
  const AgendaState();

  @override
  List<Object> get props => [];
}

class AgendaInitial extends AgendaState {}

class AgendaLoading extends AgendaState {}

class AgendaSuccess extends AgendaState {
  final AgendaResponseDTO agenda;

  const AgendaSuccess(this.agenda);

  @override
  List<Object> get props => [agenda];
}

class AgendaListSuccess extends AgendaState {
  final List<Agenda> agendas;

  const AgendaListSuccess(this.agendas);

  @override
  List<Object> get props => [agendas];
}

class AgendaFailure extends AgendaState {
  final String error;

  const AgendaFailure(this.error);

  @override
  List<Object> get props => [error];
}
