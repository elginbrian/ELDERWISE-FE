abstract class LocationHistoryEvent {}

class GetLocationHistoryEvent extends LocationHistoryEvent {
  final String locationHistoryId;
  GetLocationHistoryEvent(this.locationHistoryId);
}

class GetLocationHistoryPointsEvent extends LocationHistoryEvent {
  final String locationHistoryId;
  GetLocationHistoryPointsEvent(this.locationHistoryId);
}

class CreateLocationHistoryEvent extends LocationHistoryEvent {
  final String elderId;
  final String caregiverId;

  CreateLocationHistoryEvent({
    required this.elderId,
    required this.caregiverId,
  });
}

class AddLocationHistoryPointEvent extends LocationHistoryEvent {
  final String elderId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  AddLocationHistoryPointEvent({
    required this.elderId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });
}

class GetElderLocationHistoryEvent extends LocationHistoryEvent {
  final String elderId;
  final DateTime date;

  GetElderLocationHistoryEvent({
    required this.elderId,
    required this.date,
  });
}
