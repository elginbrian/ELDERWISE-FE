import 'package:flutter/material.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:intl/intl.dart';

class DateHeader extends StatelessWidget {
  final DateTime selectedDate;
  final Function() onTap;

  const DateHeader({
    Key? key,
    required this.selectedDate,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(selectedDate),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
            const Spacer(),
            const Icon(Icons.calendar_today_outlined,
                color: AppColors.neutral90, size: 20),
          ],
        ),
      ),
    );
  }
}
