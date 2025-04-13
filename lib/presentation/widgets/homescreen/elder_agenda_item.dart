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
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      height: 128,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 3,
            color: AppColors.neutral30,
            spreadRadius: 0,
            offset: Offset(1, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            iconImages + iconFile,
            height: 72,
            fit: BoxFit.fitHeight,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agenda.content1,
                    style: const TextStyle(
                      color: AppColors.neutral90,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Text(
                          agenda.content2,
                          style: const TextStyle(
                            color: AppColors.neutral90,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Image.asset(
                                iconImages + 'clock2.png',
                                width: 16,
                                height: 16,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                time,
                                style: const TextStyle(
                                  color: AppColors.neutral90,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
