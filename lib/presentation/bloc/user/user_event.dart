abstract class UserEvent {}

class GetUserEvent extends UserEvent {
  final String userId;
  GetUserEvent(this.userId);
}

class GetUserCaregiversEvent extends UserEvent {
  final String userId;
  GetUserCaregiversEvent(this.userId);
}

class GetUserEldersEvent extends UserEvent {
  final String userId;
  GetUserEldersEvent(this.userId);
}
