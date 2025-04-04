import 'package:elderwise/data/api/responses/area_response.dart';

abstract class AreaState {}

class AreaInitial extends AreaState {}

class AreaLoading extends AreaState {}

class AreaSuccess extends AreaState {
  final AreaResponseDTO area;
  AreaSuccess(this.area);
}

class AreasSuccess extends AreaState {
  final AreasResponseDTO areas;
  AreasSuccess(this.areas);
}

class AreaFailure extends AreaState {
  final String error;
  AreaFailure(this.error);
}
