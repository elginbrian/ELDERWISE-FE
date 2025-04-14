import 'package:flutter/material.dart';
import 'package:elderwise/presentation/themes/colors.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String content;
  final String time;
  final String type;
  final bool isRead;

  const NotificationItem({
    Key? key,
    required this.title,
    required this.content,
    required this.time,
    required this.type,
    this.isRead = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor = AppColors.primaryMain;

    switch (type.toLowerCase()) {
      case 'obat':
        iconData = Icons.medication;
        break;
      case 'makan':
        iconData = Icons.restaurant;
        break;
      case 'hidrasi':
        iconData = Icons.water_drop;
        break;
      case 'aktivitas':
        iconData = Icons.directions_run;
        break;
      case 'emergency':
        iconData = Icons.warning_amber;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.notifications;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead
            ? AppColors.neutral10
            : AppColors.primaryMain.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral30),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryMain,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              iconData,
              size: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                    color: AppColors.neutral90,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.neutral70,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    color: AppColors.neutral60,
                  ),
                ),
              ],
            ),
          ),
          if (!isRead)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryMain,
              ),
            ),
        ],
      ),
    );
  }
}
