import 'package:elderwise/domain/entities/agenda.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ElderAgendaItem extends StatelessWidget {
  final Agenda agenda;

  const ElderAgendaItem({
    Key? key,
    required this.agenda,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final type = agenda.category.toLowerCase();
    final time = DateFormat('HH:mm').format(agenda.datetime);
    String iconFile;

    switch (type) {
      case 'obat':
        iconFile = 'medicine.png';
        break;
      case 'makan':
        iconFile = 'food.png';
        break;
      case 'hidrasi':
        iconFile = 'hidration.png';
        break;
      case 'aktivitas':
        iconFile = 'activity.png';
        break;
      default:
        iconFile = 'medicine.png';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.secondarySurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(iconImages + iconFile),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agenda.category[0].toUpperCase() +
                      agenda.category.substring(1).toLowerCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    color: AppColors.neutral80,
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        agenda.content1,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: AppColors.neutral90,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (agenda.content2.isNotEmpty)
                      Text(
                        "(${agenda.content2})",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          color: AppColors.neutral70,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(iconImages + 'clock2.png'),
                      width: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        color: AppColors.neutral80,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
