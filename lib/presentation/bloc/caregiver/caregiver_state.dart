import 'package:elderwise/data/api/responses/caregiver_response.dart';

abstract class CaregiverState {}

class CaregiverInitial extends CaregiverState {}

class CaregiverLoading extends CaregiverState {}

class CaregiverSuccess extends CaregiverState {
  final CaregiverResponseDTO caregiver;
  CaregiverSuccess(this.caregiver);
}

class CaregiversSuccess extends CaregiverState {
  final CaregiversResponseDTO caregivers;
  CaregiversSuccess(this.caregivers);
}

class CaregiverFailure extends CaregiverState {
  final String error;
  CaregiverFailure(this.error);
}
