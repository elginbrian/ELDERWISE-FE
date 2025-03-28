import 'package:bloc/bloc.dart';
import 'package:elderwise/data/api/responses/agenda_response.dart';
import 'package:elderwise/domain/repositories/agenda_repository.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_event.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_state.dart';

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  final AgendaRepository agendaRepository;

  AgendaBloc(this.agendaRepository) : super(AgendaInitial()) {
    on<GetAgendaEvent>(_onGetAgenda);
    on<CreateAgendaEvent>(_onCreateAgenda);
    on<UpdateAgendaEvent>(_onUpdateAgenda);
    on<DeleteAgendaEvent>(_onDeleteAgenda);
  }

  Future<void> _onGetAgenda(
      GetAgendaEvent event, Emitter<AgendaState> emit) async {
    emit(AgendaLoading());
    try {
      final response = await agendaRepository.getAgendaByID(event.agendaId);
      if (response.success) {
        emit(AgendaSuccess(AgendaResponseDTO.fromJson(response.data)));
      } else {
        emit(AgendaFailure(response.message));
      }
    } catch (e) {
      emit(AgendaFailure(e.toString()));
    }
  }

  Future<void> _onCreateAgenda(
      CreateAgendaEvent event, Emitter<AgendaState> emit) async {
    emit(AgendaLoading());
    try {
      final response = await agendaRepository.createAgenda(event.agendaRequest);
      if (response.success) {
        emit(AgendaSuccess(AgendaResponseDTO.fromJson(response.data)));
      } else {
        emit(AgendaFailure(response.message));
      }
    } catch (e) {
      emit(AgendaFailure(e.toString()));
    }
  }

  Future<void> _onUpdateAgenda(
      UpdateAgendaEvent event, Emitter<AgendaState> emit) async {
    emit(AgendaLoading());
    try {
      final response = await agendaRepository.updateAgenda(
          event.agendaId, event.agendaRequest);
      if (response.success) {
        emit(AgendaSuccess(AgendaResponseDTO.fromJson(response.data)));
      } else {
        emit(AgendaFailure(response.message));
      }
    } catch (e) {
      emit(AgendaFailure(e.toString()));
    }
  }

  Future<void> _onDeleteAgenda(
      DeleteAgendaEvent event, Emitter<AgendaState> emit) async {
    emit(AgendaLoading());
    try {
      final response = await agendaRepository.deleteAgenda(event.agendaId);
      if (response.success) {
        emit(AgendaSuccess(AgendaResponseDTO.fromJson(response.data)));
      } else {
        emit(AgendaFailure(response.message));
      }
    } catch (e) {
      emit(AgendaFailure(e.toString()));
    }
  }
}
