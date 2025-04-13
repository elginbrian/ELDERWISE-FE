import 'package:elderwise/domain/entities/notification.dart' as domain;
import 'package:elderwise/presentation/bloc/auth/auth_bloc.dart';
import 'package:elderwise/presentation/bloc/auth/auth_event.dart';
import 'package:elderwise/presentation/bloc/auth/auth_state.dart';
import 'package:elderwise/presentation/bloc/notification/notification_bloc.dart';
import 'package:elderwise/presentation/bloc/notification/notification_event.dart';
import 'package:elderwise/presentation/bloc/notification/notification_state.dart';
import 'package:elderwise/presentation/bloc/user/user_bloc.dart';
import 'package:elderwise/presentation/bloc/user/user_event.dart';
import 'package:elderwise/presentation/bloc/user/user_state.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/screens/notification_screen/empty_notification.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/utils/toast_helper.dart';
import 'package:elderwise/presentation/widgets/notification/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _userId = '';
  String _elderId = '';
  bool _isLoading = true;
  bool _userDataLoaded = false;
  List<domain.Notification> _notifications = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(GetCurrentUserEvent());
    });
  }

  void _loadUserData() {
    if (_userId.isNotEmpty && !_userDataLoaded) {
      context.read<UserBloc>().add(GetUserEldersEvent(_userId));
      _userDataLoaded = true;
    }
  }

  void _loadNotifications() {
    if (_elderId.isNotEmpty) {
      context.read<NotificationBloc>().add(GetNotificationsEvent(_elderId));
    }
  }

  void _markAsRead(String notificationId) {
    context
        .read<NotificationBloc>()
        .add(MarkNotificationAsReadEvent(notificationId));
  }

  // Group notifications by date category
  Map<String, List<domain.Notification>> _groupNotifications() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final monthStart = DateTime(now.year, now.month, 1);

    final Map<String, List<domain.Notification>> grouped = {
      'today': [],
      'thisWeek': [],
      'thisMonth': [],
      'older': [],
    };

    for (var notification in _notifications) {
      final notifDate = DateTime(notification.datetime.year,
          notification.datetime.month, notification.datetime.day);

      if (notifDate.isAtSameMomentAs(today)) {
        grouped['today']!.add(notification);
      } else if (notifDate.isAfter(weekStart) && notifDate.isBefore(today)) {
        grouped['thisWeek']!.add(notification);
      } else if (notifDate.isAfter(monthStart) &&
          notifDate.isBefore(weekStart)) {
        grouped['thisMonth']!.add(notification);
      } else {
        grouped['older']!.add(notification);
      }
    }

    return grouped;
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 30) {
      return DateFormat('d MMM yyyy').format(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
  }

  String _getNotificationType(domain.NotificationType type) {
    switch (type) {
      case domain.NotificationType.AREA_BREACH:
        return 'aktivitas';
      case domain.NotificationType.AGENDA_OVERDUE:
        return 'obat';
      case domain.NotificationType.AGENDA_COMPLETED:
        return 'makan'; // Using 'makan' icon for completed agendas
      case domain.NotificationType.EMERGENCY_ALERT:
        return 'emergency';
      default:
        return 'aktivitas';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is CurrentUserSuccess) {
              setState(() {
                _userId = state.user.user.userId;
              });
              _loadUserData();
            } else if (state is AuthFailure) {
              ToastHelper.showErrorToast(context, state.error);
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserSuccess) {
              if (state.response.data != null && state.response.data is Map) {
                if (state.response.data.containsKey('elders') &&
                    state.response.data['elders'] is List &&
                    state.response.data['elders'].isNotEmpty) {
                  final elderData = state.response.data['elders'][0];
                  setState(() {
                    _elderId = elderData['elder_id'] ?? elderData['id'] ?? '';
                  });

                  if (_elderId.isNotEmpty) {
                    _loadNotifications();
                  }
                }
              }
            } else if (state is UserFailure) {
              ToastHelper.showErrorToast(context, state.error);
            }
          },
        ),
        BlocListener<NotificationBloc, NotificationState>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is NotificationLoading;
            });

            if (state is MarkAsReadSuccess) {
              // Reload notifications after marking as read
              _loadNotifications();
              ToastHelper.showSuccessToast(context, state.message);
            } else if (state is NotificationFailure) {
              ToastHelper.showErrorToast(context, state.error);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.primaryMain,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios,
                          color: AppColors.neutral90),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Notifikasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: AppColors.neutral90,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: AppColors.secondarySurface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: BlocConsumer<NotificationBloc, NotificationState>(
                    listener: (context, state) {
                      if (state is NotificationsSuccess) {
                        setState(() {
                          _notifications = state.notifications;
                        });
                      }
                    },
                    builder: (context, state) {
                      if (state is NotificationLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is NotificationsSuccess) {
                        if (_notifications.isEmpty) {
                          return const Center(
                            child: EmptyNotification(),
                          );
                        }

                        final groupedNotifications = _groupNotifications();

                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              vertical: 32, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (groupedNotifications['today']!
                                  .isNotEmpty) ...[
                                const Text("Hari Ini",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 12),
                                ...groupedNotifications['today']!
                                    .map((notification) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 16),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (!notification.isRead) {
                                                _markAsRead(notification
                                                    .notificationId);
                                              }
                                            },
                                            child: NotificationItem(
                                              title: notification.type
                                                  .toString()
                                                  .split('.')
                                                  .last,
                                              content: notification.message,
                                              time: _formatTimeAgo(
                                                  notification.datetime),
                                              type: _getNotificationType(
                                                  notification.type),
                                              isRead: notification.isRead,
                                            ),
                                          ),
                                        )),
                                const SizedBox(height: 24),
                              ],
                              if (groupedNotifications['thisWeek']!
                                  .isNotEmpty) ...[
                                const Text("Minggu Ini",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 12),
                                ...groupedNotifications['thisWeek']!
                                    .map((notification) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 16),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (!notification.isRead) {
                                                _markAsRead(notification
                                                    .notificationId);
                                              }
                                            },
                                            child: NotificationItem(
                                              title: notification.type
                                                  .toString()
                                                  .split('.')
                                                  .last,
                                              content: notification.message,
                                              time: _formatTimeAgo(
                                                  notification.datetime),
                                              type: _getNotificationType(
                                                  notification.type),
                                              isRead: notification.isRead,
                                            ),
                                          ),
                                        )),
                                const SizedBox(height: 24),
                              ],
                              if (groupedNotifications['thisMonth']!
                                  .isNotEmpty) ...[
                                const Text("Bulan Ini",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 12),
                                ...groupedNotifications['thisMonth']!
                                    .map((notification) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 16),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (!notification.isRead) {
                                                _markAsRead(notification
                                                    .notificationId);
                                              }
                                            },
                                            child: NotificationItem(
                                              title: notification.type
                                                  .toString()
                                                  .split('.')
                                                  .last,
                                              content: notification.message,
                                              time: _formatTimeAgo(
                                                  notification.datetime),
                                              type: _getNotificationType(
                                                  notification.type),
                                              isRead: notification.isRead,
                                            ),
                                          ),
                                        )),
                                const SizedBox(height: 24),
                              ],
                              if (groupedNotifications['older']!
                                  .isNotEmpty) ...[
                                const Text("Lebih Lama",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 12),
                                ...groupedNotifications['older']!
                                    .map((notification) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 16),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (!notification.isRead) {
                                                _markAsRead(notification
                                                    .notificationId);
                                              }
                                            },
                                            child: NotificationItem(
                                              title: notification.type
                                                  .toString()
                                                  .split('.')
                                                  .last,
                                              content: notification.message,
                                              time: _formatTimeAgo(
                                                  notification.datetime),
                                              type: _getNotificationType(
                                                  notification.type),
                                              isRead: notification.isRead,
                                            ),
                                          ),
                                        )),
                              ],
                            ],
                          ),
                        );
                      } else {
                        return const Center(
                          child: EmptyNotification(),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
