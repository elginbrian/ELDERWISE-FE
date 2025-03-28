abstract class LocationHistoryEvent {}

class GetLocationHistoryEvent extends LocationHistoryEvent {
  final String locationHistoryId;
  GetLocationHistoryEvent(this.locationHistoryId);
}

class GetLocationHistoryPointsEvent extends LocationHistoryEvent {
  final String locationHistoryId;
  GetLocationHistoryPointsEvent(this.locationHistoryId);
}
