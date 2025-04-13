import 'package:bloc/bloc.dart';
import 'package:elderwise/data/api/responses/notification_response.dart';
import 'package:elderwise/domain/repositories/notification_repository.dart';
import 'package:elderwise/presentation/bloc/notification/notification_event.dart';
import 'package:elderwise/presentation/bloc/notification/notification_state.dart';
import 'package:flutter/material.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;

  NotificationBloc(this.notificationRepository) : super(NotificationInitial()) {
    on<GetNotificationsEvent>(_onGetNotifications);
    on<CheckNotificationsEvent>(_onCheckNotifications);
    on<GetUnreadCountEvent>(_onGetUnreadCount);
    on<MarkNotificationAsReadEvent>(_onMarkNotificationAsRead);
  }

  Future<void> _onGetNotifications(
    GetNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      final response =
          await notificationRepository.getNotifications(event.elderId);

      debugPrint('Response success: ${response.success}');
      debugPrint('Response message: ${response.message}');

      if (response.success) {
        try {
          final notificationsData =
              NotificationsResponseDTO.fromJson(response.data);
          emit(NotificationsSuccess(notificationsData.notifications));
        } catch (e) {
          debugPrint('Error in notifications data processing: $e');
          emit(NotificationFailure('Error processing notifications data'));
        }
      } else {
        emit(NotificationFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get notifications exception: $e');
      emit(NotificationFailure(e.toString()));
    }
  }

  Future<void> _onCheckNotifications(
    CheckNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      final response =
          await notificationRepository.checkNotifications(event.elderId);

      if (response.success) {
        try {
          final notificationsData =
              NotificationsResponseDTO.fromJson(response.data);
          emit(NotificationsSuccess(notificationsData.notifications));
        } catch (e) {
          debugPrint('Error in notifications check processing: $e');
          emit(NotificationFailure('Error processing notifications check'));
        }
      } else {
        emit(NotificationFailure(response.message));
      }
    } catch (e) {
      debugPrint('Check notifications exception: $e');
      emit(NotificationFailure(e.toString()));
    }
  }

  Future<void> _onGetUnreadCount(
    GetUnreadCountEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      final response =
          await notificationRepository.getUnreadCount(event.elderId);

      if (response.success) {
        try {
          final countData = UnreadCountResponseDTO.fromJson(response.data);
          emit(UnreadCountSuccess(countData.count));
        } catch (e) {
          debugPrint('Error in unread count processing: $e');
          emit(NotificationFailure('Error processing unread count'));
        }
      } else {
        emit(NotificationFailure(response.message));
      }
    } catch (e) {
      debugPrint('Get unread count exception: $e');
      emit(NotificationFailure(e.toString()));
    }
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      final response = await notificationRepository
          .markNotificationAsRead(event.notificationId);

      if (response.success) {
        emit(MarkAsReadSuccess(response.message));
      } else {
        emit(NotificationFailure(response.message));
      }
    } catch (e) {
      debugPrint('Mark notification as read exception: $e');
      emit(NotificationFailure(e.toString()));
    }
  }
}
