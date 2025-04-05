import 'package:bloc/bloc.dart';
import 'package:elderwise/data/api/responses/location_history_response.dart';
import 'package:elderwise/domain/repositories/location_history_repository.dart';
import 'package:elderwise/presentation/bloc/location_history/location_history_event.dart';
import 'package:elderwise/presentation/bloc/location_history/location_history_state.dart';
import 'package:flutter/material.dart';

class LocationHistoryBloc
    extends Bloc<LocationHistoryEvent, LocationHistoryState> {
  final LocationHistoryRepository repository;

  LocationHistoryBloc(this.repository) : super(LocationHistoryInitial()) {
    on<GetLocationHistoryEvent>(_onGetHistory);
    on<GetLocationHistoryPointsEvent>(_onGetHistoryPoints);
  }

  Future<void> _onGetHistory(
      GetLocationHistoryEvent event, Emitter<LocationHistoryState> emit) async {
    emit(LocationHistoryLoading());
    try {
      final response =
          await repository.getLocationHistoryByID(event.locationHistoryId);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(LocationHistorySuccess(
              LocationHistoryResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in location history data processing: $e');
          emit(
              LocationHistoryFailure('Error processing location history data'));
        }
      } else {
        emit(LocationHistoryFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get location history exception: $e');
      emit(LocationHistoryFailure(e.toString()));
    }
  }

  Future<void> _onGetHistoryPoints(GetLocationHistoryPointsEvent event,
      Emitter<LocationHistoryState> emit) async {
    emit(LocationHistoryLoading());
    try {
      final response =
          await repository.getLocationHistoryPoints(event.locationHistoryId);

      debugPrint('Complete response structure: ${response.runtimeType}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response data type: ${response.data.runtimeType}');

      if (response.success) {
        try {
          emit(LocationHistoryPointsSuccess(
              LocationHistoryPointsResponseDTO.fromJson(response.data)));
        } catch (e) {
          debugPrint('Error in location history points data processing: $e');
          emit(LocationHistoryFailure(
              'Error processing location history points data'));
        }
      } else {
        emit(LocationHistoryFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get location history points exception: $e');
      emit(LocationHistoryFailure(e.toString()));
    }
  }
}
