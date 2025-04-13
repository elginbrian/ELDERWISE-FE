import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/screens/notification_screen/empty_notification.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/notification/notification_item.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, String>> newNotifications = [
    {
      'title': 'Minum Obat',
      'content': 'Waktunya minum obat Paracetamol',
      'time': 'Baru saja',
      'type': 'obat',
    },
  ];

  final List<Map<String, String>> thisWeekNotifications = [
    {
      'title': 'Sarapan',
      'content': 'Jangan lupa sarapan pagi ini',
      'time': '2 hari lalu',
      'type': 'makan',
    },
  ];

  final List<Map<String, String>> thisMonthNotifications = [
    {
      'title': 'Jalan Santai',
      'content': 'Ayo aktivitas ringan untuk tubuh sehat',
      'time': '3 minggu lalu',
      'type': 'aktivitas',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isAllEmpty = newNotifications.isEmpty &&
        thisWeekNotifications.isEmpty &&
        thisMonthNotifications.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.primaryMain,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                child: isAllEmpty
                    ? Center(
                        child: EmptyNotification(),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            vertical: 32, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (newNotifications.isNotEmpty) ...[
                              const Text("Baru Saja",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 12),
                              ...newNotifications.map((notif) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: NotificationItem(
                                      title: notif['title']!,
                                      content: notif['content']!,
                                      time: notif['time']!,
                                      type: notif['type']!,
                                    ),
                                  )),
                              const SizedBox(height: 24),
                            ],
                            if (thisWeekNotifications.isNotEmpty) ...[
                              const Text("Minggu Ini",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 12),
                              ...thisWeekNotifications.map((notif) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: NotificationItem(
                                      title: notif['title']!,
                                      content: notif['content']!,
                                      time: notif['time']!,
                                      type: notif['type']!,
                                    ),
                                  )),
                              const SizedBox(height: 24),
                            ],
                            if (thisMonthNotifications.isNotEmpty) ...[
                              const Text("Bulan Ini",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 12),
                              ...thisMonthNotifications.map((notif) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: NotificationItem(
                                      title: notif['title']!,
                                      content: notif['content']!,
                                      time: notif['time']!,
                                      type: notif['type']!,
                                    ),
                                  )),
                            ]
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
