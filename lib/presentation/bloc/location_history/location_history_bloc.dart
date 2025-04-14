import 'package:bloc/bloc.dart';
import 'package:elderwise/data/api/requests/location_history_request.dart';
import 'package:elderwise/data/api/responses/location_history_response.dart';
import 'package:elderwise/domain/repositories/location_history_repository.dart';
import 'package:elderwise/domain/repositories/elder_repository.dart';
import 'package:elderwise/presentation/bloc/location_history/location_history_event.dart';
import 'package:elderwise/presentation/bloc/location_history/location_history_state.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class LocationHistoryBloc
    extends Bloc<LocationHistoryEvent, LocationHistoryState> {
  final LocationHistoryRepository repository;
  late ElderRepository elderRepository;

  LocationHistoryBloc(this.repository) : super(LocationHistoryInitial()) {
    on<GetLocationHistoryEvent>(_onGetHistory);
    on<GetLocationHistoryPointsEvent>(_onGetHistoryPoints);
    on<CreateLocationHistoryEvent>(_onCreateLocationHistory);
    on<AddLocationHistoryPointEvent>(_onAddLocationHistoryPoint);
    on<GetElderLocationHistoryEvent>(_onGetElderLocationHistoryByDate);

    try {
      elderRepository = GetIt.I<ElderRepository>();
    } catch (e) {
      debugPrint('Warning: Elder repository not available: $e');
    }
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

  Future<void> _onCreateLocationHistory(CreateLocationHistoryEvent event,
      Emitter<LocationHistoryState> emit) async {
    emit(LocationHistoryLoading());
    try {
      final request = LocationHistoryRequestDTO(
        elderId: event.elderId,
        caregiverId: event.caregiverId,
        createdAt: DateTime.now().toUtc(),
      );

      final response = await repository.createLocationHistory(request);

      if (response.success) {
        try {
          emit(LocationHistorySuccess(
              LocationHistoryResponseDTO.fromJson(response.data)));
          debugPrint('Successfully created location history');
        } catch (e) {
          debugPrint('Error processing location history data: $e');
          emit(
              LocationHistoryFailure('Error processing location history data'));
        }
      } else {
        emit(LocationHistoryFailure(response.message));
      }
    } catch (e) {
      debugPrint('Create location history exception: $e');
      emit(LocationHistoryFailure(e.toString()));
    }
  }

  Future<void> _onAddLocationHistoryPoint(AddLocationHistoryPointEvent event,
      Emitter<LocationHistoryState> emit) async {
    try {
      debugPrint(
          'Received location update for elder ${event.elderId}: ${event.latitude}, ${event.longitude}');

      try {
        final historyResponse =
            await elderRepository.getElderLocationHistory(event.elderId);

        if (historyResponse.success && historyResponse.data != null) {
          final locationHistoryId = historyResponse.data['id'] ??
              historyResponse.data['location_history_id'];

          if (locationHistoryId != null) {
            await _addPointToHistory(locationHistoryId, event.latitude,
                event.longitude, event.timestamp);
          } else {
            debugPrint('Location history ID not found, creating new history');
            await _createHistoryAndAddPoint(event);
          }
        } else {
          debugPrint('No location history found, creating new history');
          await _createHistoryAndAddPoint(event);
        }
      } catch (e) {
        debugPrint('Error accessing elder location history: $e');
      }
    } catch (e) {
      debugPrint('Error handling location point: $e');
    }
  }

  Future<void> _createHistoryAndAddPoint(
      AddLocationHistoryPointEvent event) async {
    try {
      String caregiverId = event.elderId;

      final request = LocationHistoryRequestDTO(
        elderId: event.elderId,
        caregiverId: caregiverId,
        createdAt: DateTime.now().toUtc(),
      );

      final response = await repository.createLocationHistory(request);

      if (response.success && response.data != null) {
        final locationHistoryId =
            response.data['id'] ?? response.data['location_history_id'];

        if (locationHistoryId != null) {
          await _addPointToHistory(locationHistoryId, event.latitude,
              event.longitude, event.timestamp);
        }
      }
    } catch (e) {
      debugPrint('Failed to create history and add point: $e');
    }
  }

  Future<void> _addPointToHistory(String locationHistoryId, double latitude,
      double longitude, DateTime timestamp) async {
    try {
      final pointRequest = LocationHistoryPointRequestDTO(
        locationHistoryId: locationHistoryId,
        latitude: latitude,
        longitude: longitude,
        timestamp: timestamp,
      );

      final response = await repository.addLocationPoint(
        locationHistoryId,
        pointRequest,
      );

      if (response.success) {
        debugPrint(
            'Successfully added location point to history $locationHistoryId');
      } else {
        debugPrint('Failed to add location point: ${response.message}');
      }
    } catch (e) {
      debugPrint('Error adding location point: $e');
    }
  }

  Future<void> _onGetElderLocationHistoryByDate(
      GetElderLocationHistoryEvent event,
      Emitter<LocationHistoryState> emit) async {
    emit(LocationHistoryLoading());
    try {
      final response =
          await elderRepository.getElderLocationHistory(event.elderId);

      if (response.success) {
        try {
          final historyData = response.data;

          if (historyData != null) {
            emit(LocationHistorySuccess(
                LocationHistoryResponseDTO.fromJson(historyData)));
          } else {
            emit(LocationHistoryFailure(
                'No location history found for this date'));
          }
        } catch (e) {
          debugPrint('Error processing location history data: $e');
          emit(
              LocationHistoryFailure('Error processing location history data'));
        }
      } else {
        emit(LocationHistoryFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get elder location history by date exception: $e');
      emit(LocationHistoryFailure(e.toString()));
    }
  }
}
