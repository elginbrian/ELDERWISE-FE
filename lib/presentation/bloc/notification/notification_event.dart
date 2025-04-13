import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class GetNotificationsEvent extends NotificationEvent {
  final String elderId;

  const GetNotificationsEvent(this.elderId);

  @override
  List<Object> get props => [elderId];
}

class CheckNotificationsEvent extends NotificationEvent {
  final String elderId;

  const CheckNotificationsEvent(this.elderId);

  @override
  List<Object> get props => [elderId];
}

class GetUnreadCountEvent extends NotificationEvent {
  final String elderId;

  const GetUnreadCountEvent(this.elderId);

  @override
  List<Object> get props => [elderId];
}

class MarkNotificationAsReadEvent extends NotificationEvent {
  final String notificationId;

  const MarkNotificationAsReadEvent(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}
