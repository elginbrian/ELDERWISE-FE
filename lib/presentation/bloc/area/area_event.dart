import 'package:elderwise/data/api/requests/area_request.dart';

abstract class AreaEvent {}

class GetAreaEvent extends AreaEvent {
  final String areaId;
  GetAreaEvent(this.areaId);
}

class CreateAreaEvent extends AreaEvent {
  final AreaRequestDTO areaRequest;
  CreateAreaEvent(this.areaRequest);
}

class UpdateAreaEvent extends AreaEvent {
  final String areaId;
  final AreaRequestDTO areaRequest;
  UpdateAreaEvent(this.areaId, this.areaRequest);
}

class DeleteAreaEvent extends AreaEvent {
  final String areaId;
  DeleteAreaEvent(this.areaId);
}

class GetAreasByCaregiverEvent extends AreaEvent {
  final String caregiverId;
  GetAreasByCaregiverEvent(this.caregiverId);
}
