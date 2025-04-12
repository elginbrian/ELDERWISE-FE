import 'package:flutter/material.dart';
import 'package:elderwise/presentation/themes/colors.dart';

class WeekSelector extends StatelessWidget {
  final List<DateTime> daysInWeek;
  final DateTime selectedDate;
  final List<String> weekdays;
  final Function(DateTime) onDateSelected;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  const WeekSelector({
    Key? key,
    required this.daysInWeek,
    required this.selectedDate,
    required this.weekdays,
    required this.onDateSelected,
    required this.onPreviousWeek,
    required this.onNextWeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Position chevron left at the edge
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.chevron_left, color: AppColors.neutral90),
          onPressed: onPreviousWeek,
        ),
        // Day selector takes the center space
        Expanded(
          child: SizedBox(
            height: 70,
            child: Row(
              children: List.generate(7, (index) {
                final day = daysInWeek[index];
                final isSelected = day.year == selectedDate.year &&
                    day.month == selectedDate.month &&
                    day.day == selectedDate.day;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onDateSelected(day),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryMain
                            : AppColors.secondarySurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${day.day}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              color: isSelected
                                  ? AppColors.neutral90
                                  : AppColors.neutral70,
                            ),
                          ),
                          Text(
                            weekdays[day.weekday - 1].substring(0, 3),
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Poppins',
                              color: isSelected
                                  ? AppColors.neutral90
                                  : AppColors.neutral70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        // Position chevron right at the edge
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.chevron_right, color: AppColors.neutral90),
          onPressed: onNextWeek,
        ),
      ],
    );
  }
}
