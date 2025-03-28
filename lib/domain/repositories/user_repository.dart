import 'package:elderwise/data/api/responses/response_wrapper.dart';

abstract class UserRepository {
  Future<ResponseWrapper> getUserByID(String userId);
  Future<ResponseWrapper> getUserCaregivers(String userId);
  Future<ResponseWrapper> getUserElders(String userId);
}
