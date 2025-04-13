import 'package:dio/dio.dart';
import 'package:elderwise/data/api/api_config.dart';
import 'package:elderwise/data/api/responses/response_wrapper.dart';
import 'package:elderwise/domain/repositories/notification_repository.dart';
import 'package:flutter/material.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final Dio dio;

  NotificationRepositoryImpl({Dio? dio}) : dio = dio ?? ApiConfig.dio;

  @override
  Future<ResponseWrapper> getNotifications(String elderId) async {
    try {
      final response = await dio.get(ApiConfig.getNotifications(elderId));
      debugPrint("Repository: ${response.data}");
      return ResponseWrapper.fromJson(response.data);
    } catch (e) {
      debugPrint("Error getting notifications: $e");
      return ResponseWrapper(
        success: false,
        message: "Failed to retrieve notifications",
        error: e.toString(),
      );
    }
  }

  @override
  Future<ResponseWrapper> checkNotifications(String elderId) async {
    try {
      final response = await dio.get(ApiConfig.checkNotifications(elderId));
      debugPrint("Repository: ${response.data}");
      return ResponseWrapper.fromJson(response.data);
    } catch (e) {
      debugPrint("Error checking notifications: $e");
      return ResponseWrapper(
        success: false,
        message: "Failed to check for notifications",
        error: e.toString(),
      );
    }
  }

  @override
  Future<ResponseWrapper> getUnreadCount(String elderId) async {
    try {
      final response = await dio.get(ApiConfig.getUnreadCount(elderId));
      debugPrint("Repository: ${response.data}");
      return ResponseWrapper.fromJson(response.data);
    } catch (e) {
      debugPrint("Error getting unread count: $e");
      return ResponseWrapper(
        success: false,
        message: "Failed to retrieve unread count",
        error: e.toString(),
      );
    }
  }

  @override
  Future<ResponseWrapper> markNotificationAsRead(String notificationId) async {
    try {
      final response =
          await dio.put(ApiConfig.markNotificationAsRead(notificationId));
      debugPrint("Repository: ${response.data}");
      return ResponseWrapper.fromJson(response.data);
    } catch (e) {
      debugPrint("Error marking notification as read: $e");
      return ResponseWrapper(
        success: false,
        message: "Failed to mark notification as read",
        error: e.toString(),
      );
    }
  }
}
