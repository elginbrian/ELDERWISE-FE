import 'package:elderwise/domain/entities/caregiver.dart';

abstract class CaregiverEvent {}

class GetCaregiverEvent extends CaregiverEvent {
  final String caregiverId;
  GetCaregiverEvent(this.caregiverId);
}

class CreateCaregiverEvent extends CaregiverEvent {
  final Caregiver caregiver;
  CreateCaregiverEvent(this.caregiver);
}

class UpdateCaregiverEvent extends CaregiverEvent {
  final String caregiverId;
  final Caregiver caregiver;
  UpdateCaregiverEvent(this.caregiverId, this.caregiver);
}
