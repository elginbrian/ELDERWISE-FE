import 'package:flutter/material.dart';
import 'package:elderwise/presentation/themes/colors.dart';

class ReminderContent extends StatelessWidget {
  final String type;
  final String title;
  final String? dose;

  const ReminderContent({
    super.key,
    required this.type,
    required this.title,
    this.dose,
  });

  String get theType {
    switch (type.toLowerCase()) {
      case 'makan':
        return 'Makan';
      case 'hidrasi':
        return 'Minum';
      case 'obat':
        return 'Minum Obat';
      case 'aktivitas':
        return 'beraktivitas';
      default:
        return 'Minum Obat';
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor = Colors.black;

    switch (type.toLowerCase()) {
      case 'makan':
        iconData = Icons.restaurant;
        break;
      case 'hidrasi':
        iconData = Icons.water_drop;
        break;
      case 'obat':
        iconData = Icons.medication;
        break;
      case 'aktivitas':
        iconData = Icons.directions_run;
        break;
      default:
        iconData = Icons.notifications_active;
    }

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.primaryMain,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryMain.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              iconData,
              size: 100,
              color: iconColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 8),
            child: Text(
              "Saatnya $theType!",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          dose != null
              ? Text(
                  dose!,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
