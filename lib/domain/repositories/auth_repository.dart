import 'package:elderwise/data/api/requests/auth_request.dart';
import 'package:elderwise/data/api/responses/response_wrapper.dart';

abstract class AuthRepository {
  Future<ResponseWrapper> register(RegisterRequestDTO request);
  Future<ResponseWrapper> login(LoginRequestDTO request);
}
