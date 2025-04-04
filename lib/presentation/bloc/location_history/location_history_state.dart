import 'package:elderwise/data/api/responses/location_history_response.dart';

abstract class LocationHistoryState {}

class LocationHistoryInitial extends LocationHistoryState {}

class LocationHistoryLoading extends LocationHistoryState {}

class LocationHistorySuccess extends LocationHistoryState {
  final LocationHistoryResponseDTO response;
  LocationHistorySuccess(this.response);
}

class LocationHistoryPointsSuccess extends LocationHistoryState {
  final LocationHistoryPointsResponseDTO response;
  LocationHistoryPointsSuccess(this.response);
}

class LocationHistoryFailure extends LocationHistoryState {
  final String error;
  LocationHistoryFailure(this.error);
}
