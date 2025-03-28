import 'package:elderwise/data/api/requests/area_request.dart';
import 'package:elderwise/data/api/responses/response_wrapper.dart';

abstract class AreaRepository {
  Future<ResponseWrapper> getAreaByID(String areaId);
  Future<ResponseWrapper> createArea(AreaRequestDTO areaRequest);
  Future<ResponseWrapper> updateArea(String areaId, AreaRequestDTO areaRequest);
  Future<ResponseWrapper> deleteArea(String areaId);
  Future<ResponseWrapper> getAreasByCaregiver(String caregiverId);
}
