import 'package:elderwise/data/api/responses/response_wrapper.dart';

abstract class LocationHistoryRepository {
  Future<ResponseWrapper> getLocationHistoryByID(String locationHistoryId);
  Future<ResponseWrapper> getLocationHistoryPoints(String locationHistoryId);
}
