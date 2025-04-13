import 'package:elderwise/domain/entities/notification.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsSuccess extends NotificationState {
  final List<Notification> notifications;

  const NotificationsSuccess(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class MarkAsReadSuccess extends NotificationState {
  final String message;

  const MarkAsReadSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class UnreadCountSuccess extends NotificationState {
  final int count;

  const UnreadCountSuccess(this.count);

  @override
  List<Object> get props => [count];
}

class NotificationFailure extends NotificationState {
  final String error;

  const NotificationFailure(this.error);

  @override
  List<Object> get props => [error];
}
