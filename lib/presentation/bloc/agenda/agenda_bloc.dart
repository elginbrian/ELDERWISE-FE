import 'package:bloc/bloc.dart';
import 'package:elderwise/data/api/requests/agenda_request.dart';
import 'package:elderwise/data/api/responses/agenda_response.dart';
import 'package:elderwise/domain/entities/agenda.dart';
import 'package:elderwise/domain/repositories/agenda_repository.dart';
import 'package:elderwise/domain/repositories/elder_repository.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_event.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_state.dart';
import 'package:flutter/material.dart';

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  final AgendaRepository agendaRepository;
  final ElderRepository elderRepository;

  AgendaBloc(this.agendaRepository, this.elderRepository)
      : super(AgendaInitial()) {
    on<GetAgendaEvent>(_onGetAgenda);
    on<GetAgendasByElderIdEvent>(_onGetAgendasByElderId);
    on<CreateAgendaEvent>(_onCreateAgenda);
    on<UpdateAgendaEvent>(_onUpdateAgenda);
    on<DeleteAgendaEvent>(_onDeleteAgenda);
    on<UpdateAgendaStatusEvent>(_onUpdateAgendaStatus);
  }

  Future<void> _onGetAgenda(
      GetAgendaEvent event, Emitter<AgendaState> emit) async {
    emit(AgendaLoading());
    try {
      final response = await agendaRepository.getAgendaByID(event.agendaId);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(AgendaSuccess(AgendaResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in agenda data processing: $e');
          emit(AgendaFailure('Error processing agenda data'));
        }
      } else {
        emit(AgendaFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get agenda exception: $e');
      emit(AgendaFailure(e.toString()));
    }
  }

  Future<void> _onGetAgendasByElderId(
      GetAgendasByElderIdEvent event, Emitter<AgendaState> emit) async {
    emit(AgendaLoading());
    try {
      final response = await elderRepository.getElderAgendas(event.elderId);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          final agendasData = AgendasResponseDTO.fromJson(response.data);
          emit(AgendaListSuccess(agendasData.agendas));
        } catch (e) {
          debugPrint('Error in agendas data processing: $e');
          emit(AgendaFailure('Error processing agendas data'));
        }
      } else {
        emit(AgendaFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get elder agendas exception: $e');
      emit(AgendaFailure(e.toString()));
    }
  }

  Future<void> _onCreateAgenda(
      CreateAgendaEvent event, Emitter<AgendaState> emit) async {
    emit(AgendaLoading());
    try {
      final response = await agendaRepository.createAgenda(event.agendaRequest);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(AgendaSuccess(AgendaResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in agenda data processing: $e');
          emit(AgendaFailure('Error processing agenda data'));
        }
      } else {
        emit(AgendaFailure(response.message));
      }
    } catch (e) {
      debugPrint('Create agenda exception: $e');
      emit(AgendaFailure(e.toString()));
    }
  }

  Future<void> _onUpdateAgenda(
      UpdateAgendaEvent event, Emitter<AgendaState> emit) async {
    emit(AgendaLoading());
    try {
      final response = await agendaRepository.updateAgenda(
          event.agendaId, event.agendaRequest);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(AgendaSuccess(AgendaResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in agenda data processing: $e');
          emit(AgendaFailure('Error processing agenda data'));
        }
      } else {
        emit(AgendaFailure(response.message));
      }
    } catch (e) {
      debugPrint('Update agenda exception: $e');
      emit(AgendaFailure(e.toString()));
    }
  }

  Future<void> _onDeleteAgenda(
      DeleteAgendaEvent event, Emitter<AgendaState> emit) async {
    emit(AgendaLoading());
    try {
      final response = await agendaRepository.deleteAgenda(event.agendaId);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(AgendaSuccess(AgendaResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in agenda data processing: $e');
          emit(AgendaFailure('Error processing agenda data'));
        }
      } else {
        emit(AgendaFailure(response.message));
      }
    } catch (e) {
      debugPrint('Delete agenda exception: $e');
      emit(AgendaFailure(e.toString()));
    }
  }

  Future<void> _onUpdateAgendaStatus(
    UpdateAgendaStatusEvent event,
    Emitter<AgendaState> emit,
  ) async {
    emit(AgendaLoading());
    try {
      final response = await agendaRepository.updateAgenda(
        event.agendaId,
        AgendaRequestDTO(
            elderId: event.agenda.elderId,
            caregiverId: event.agenda.caregiverId,
            category: event.agenda.category,
            content1: event.agenda.content1,
            content2: event.agenda.content2,
            datetime: event.agenda.datetime.toIso8601String(),
            isFinished: event.agenda.isFinished),
      );

      if (response.success) {
        try {
          emit(AgendaSuccess(AgendaResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in agenda status update processing: $e');
          emit(AgendaFailure('Error processing agenda status update'));
        }
      } else {
        emit(AgendaFailure(response.message));
      }
    } catch (e) {
      debugPrint('Update agenda status exception: $e');
      emit(AgendaFailure(e.toString()));
    }
  }
}
