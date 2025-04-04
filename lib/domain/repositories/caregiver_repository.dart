import 'package:elderwise/data/api/responses/response_wrapper.dart';
import 'package:elderwise/domain/entities/caregiver.dart';

abstract class CaregiverRepository {
  Future<ResponseWrapper> getCaregiverByID(String caregiverId);
  Future<ResponseWrapper> createCaregiver(Caregiver caregiverRequest);
  Future<ResponseWrapper> updateCaregiver(
      String caregiverId, Caregiver caregiverRequest);
}
