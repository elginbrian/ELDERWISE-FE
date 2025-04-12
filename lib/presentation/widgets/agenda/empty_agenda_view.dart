import 'package:flutter/material.dart';
import 'package:elderwise/presentation/themes/colors.dart';

class EmptyAgendaView extends StatelessWidget {
  final String message;

  const EmptyAgendaView({
    Key? key,
    this.message = 'Tidak ada agenda untuk hari ini',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: AppColors.neutral70.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              color: AppColors.neutral70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
