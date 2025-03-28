import 'package:bloc/bloc.dart';
import 'package:elderwise/data/api/responses/location_history_response.dart';
import 'package:elderwise/domain/repositories/location_history_repository.dart';
import 'package:elderwise/presentation/bloc/location_history/location_history_event.dart';
import 'package:elderwise/presentation/bloc/location_history/location_history_state.dart';

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
      if (response.success) {
        emit(LocationHistorySuccess(
            LocationHistoryResponseDTO.fromJson(response.data)));
      } else {
        emit(LocationHistoryFailure(response.message));
      }
    } catch (e) {
      emit(LocationHistoryFailure(e.toString()));
    }
  }

  Future<void> _onGetHistoryPoints(GetLocationHistoryPointsEvent event,
      Emitter<LocationHistoryState> emit) async {
    emit(LocationHistoryLoading());
    try {
      final response =
          await repository.getLocationHistoryPoints(event.locationHistoryId);
      if (response.success) {
        emit(LocationHistoryPointsSuccess(
            LocationHistoryPointsResponseDTO.fromJson(response.data)));
      } else {
        emit(LocationHistoryFailure(response.message));
      }
    } catch (e) {
      emit(LocationHistoryFailure(e.toString()));
    }
  }
}
