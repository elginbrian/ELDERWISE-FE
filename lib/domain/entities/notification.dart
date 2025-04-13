import 'package:flutter/material.dart';

enum NotificationType {
  AREA_BREACH,
  AGENDA_OVERDUE,
  AGENDA_COMPLETED,
  EMERGENCY_ALERT,
}

extension NotificationTypeExtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.AREA_BREACH:
        return 'AREA_BREACH';
      case NotificationType.AGENDA_OVERDUE:
        return 'AGENDA_OVERDUE';
      case NotificationType.AGENDA_COMPLETED:
        return 'AGENDA_COMPLETED';
      case NotificationType.EMERGENCY_ALERT:
        return 'EMERGENCY_ALERT';
    }
  }

  static NotificationType fromString(String value) {
    switch (value) {
      case 'AREA_BREACH':
        return NotificationType.AREA_BREACH;
      case 'AGENDA_OVERDUE':
        return NotificationType.AGENDA_OVERDUE;
      case 'AGENDA_COMPLETED':
        return NotificationType.AGENDA_COMPLETED;
      case 'EMERGENCY_ALERT':
        return NotificationType.EMERGENCY_ALERT;
      default:
        throw ArgumentError('Unknown NotificationType: $value');
    }
  }
}

class Notification {
  final String notificationId;
  final String elderId;
  final NotificationType type;
  final String message;
  final DateTime datetime;
  final bool isRead;
  final String relatedId;
  final DateTime createdAt;

  Notification({
    required this.notificationId,
    required this.elderId,
    required this.type,
    required this.message,
    required this.datetime,
    required this.isRead,
    required this.relatedId,
    required this.createdAt,
  });

  factory Notification.fromJson(dynamic json) {
    debugPrint('Notification.fromJson called with: ${json.runtimeType}');

    try {
      if (json is Map<String, dynamic>) {
        final requiredFields = [
          'notification_id',
          'elder_id',
          'type',
          'message',
          'datetime',
          'is_read',
          'related_id',
          'created_at',
        ];

        for (final field in requiredFields) {
          if (!json.containsKey(field)) {
            throw FormatException(
                'Missing required field: $field in notification data: $json');
          }
        }

        return Notification(
          notificationId: json['notification_id'] as String,
          elderId: json['elder_id'] as String,
          type: NotificationTypeExtension.fromString(json['type'] as String),
          message: json['message'] as String,
          datetime: DateTime.parse(json['datetime'] as String),
          isRead: json['is_read'] as bool,
          relatedId: json['related_id'] as String,
          createdAt: DateTime.parse(json['created_at'] as String),
        );
      } else {
        throw FormatException(
            'Unsupported JSON format for notification: $json');
      }
    } catch (e) {
      debugPrint('Error in Notification.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_id': notificationId,
      'elder_id': elderId,
      'type': type.value,
      'message': message,
      'datetime': datetime.toIso8601String(),
      'is_read': isRead,
      'related_id': relatedId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
