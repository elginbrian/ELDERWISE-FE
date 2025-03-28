import 'package:elderwise/data/api/responses/response_wrapper.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final ResponseWrapper response;
  UserSuccess(this.response);
}

class UserFailure extends UserState {
  final String error;
  UserFailure(this.error);
}
