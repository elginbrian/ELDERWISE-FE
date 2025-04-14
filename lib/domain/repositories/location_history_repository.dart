import 'package:elderwise/data/api/requests/location_history_request.dart';
import 'package:elderwise/data/api/responses/response_wrapper.dart';

abstract class LocationHistoryRepository {
  Future<ResponseWrapper> getLocationHistoryByID(String locationHistoryId);
  Future<ResponseWrapper> getLocationHistoryPoints(String locationHistoryId);
  Future<ResponseWrapper> addLocationPoint(
      String locationHistoryId, LocationHistoryPointRequestDTO requestDTO);
  Future<ResponseWrapper> createLocationHistory(
      LocationHistoryRequestDTO requestDTO);
}
