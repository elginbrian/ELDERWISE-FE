import 'package:flutter/material.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String content;
  final String time;
  final String type;

  const NotificationItem({
    Key? key,
    required this.title,
    required this.content,
    required this.time,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String iconFile;
    switch (type.toLowerCase()) {
      case 'obat':
        iconFile = 'medicine.png';
        break;
      case 'makan':
        iconFile = 'food.png';
        break;
      case 'hidrasi':
        iconFile = 'hydration.png';
        break;
      case 'aktivitas':
        iconFile = 'activity.png';
        break;
      default:
        iconFile = 'default.png';
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.secondarySurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            offset: const Offset(0, 2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            child: Image(image: AssetImage(iconImages + iconFile)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
