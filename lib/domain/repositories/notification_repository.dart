import 'package:elderwise/data/api/responses/response_wrapper.dart';

abstract class NotificationRepository {
  Future<ResponseWrapper> getNotifications(String elderId);
  Future<ResponseWrapper> checkNotifications(String elderId);
  Future<ResponseWrapper> getUnreadCount(String elderId);
  Future<ResponseWrapper> markNotificationAsRead(String notificationId);
}
