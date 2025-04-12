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
      backgroundColor: AppColors.secondarySurface,
      appBar: AppBar(
        backgroundColor: AppColors.secondarySurface,
        title: const Text(
          "Notifikasi",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
body: Padding(
  padding: const EdgeInsets.all(32.0),
  child: isAllEmpty
      ? Expanded(
        child: Center(
          child: Center(
              child: EmptyNotification(),
            ),
        ),
      )
            : SingleChildScrollView(
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
    );
  }
}
