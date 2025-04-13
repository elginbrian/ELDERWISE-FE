import 'package:elderwise/domain/entities/notification.dart' as domain;
import 'package:flutter/material.dart';

class NotificationsResponseDTO {
  final List<domain.Notification> notifications;

  NotificationsResponseDTO({required this.notifications});

  factory NotificationsResponseDTO.fromJson(dynamic json) {
    debugPrint('NotificationsResponseDTO.fromJson: ${json.runtimeType}');
    try {
      if (json is Map<String, dynamic> && json.containsKey('notifications')) {
        final notificationsJson = json['notifications'] as List;
        final notifications = notificationsJson
            .map((notificationJson) =>
                domain.Notification.fromJson(notificationJson))
            .toList();
        return NotificationsResponseDTO(notifications: notifications);
      } else {
        throw FormatException(
            'Invalid JSON format for NotificationsResponseDTO');
      }
    } catch (e) {
      debugPrint('Error in NotificationsResponseDTO.fromJson: $e');
      rethrow;
    }
  }
}

class UnreadCountResponseDTO {
  final int count;

  UnreadCountResponseDTO({required this.count});

  factory UnreadCountResponseDTO.fromJson(dynamic json) {
    debugPrint('UnreadCountResponseDTO.fromJson: ${json.runtimeType}');
    try {
      if (json is Map<String, dynamic> && json.containsKey('count')) {
        return UnreadCountResponseDTO(count: json['count'] as int);
      } else {
        throw FormatException('Invalid JSON format for UnreadCountResponseDTO');
      }
    } catch (e) {
      debugPrint('Error in UnreadCountResponseDTO.fromJson: $e');
      rethrow;
    }
  }
}
