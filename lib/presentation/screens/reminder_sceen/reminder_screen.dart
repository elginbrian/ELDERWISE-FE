import 'package:elderwise/domain/entities/agenda.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:elderwise/presentation/widgets/notification/reminder_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderScreen extends StatelessWidget {
  final Agenda agenda;
  final Function(String agendaId) onCompleted;
  final VoidCallback onDismissed;

  const ReminderScreen({
    Key? key,
    required this.agenda,
    required this.onCompleted,
    required this.onDismissed,
  }) : super(key: key);

  String _getTimeString() {
    return DateFormat('HH:mm').format(agenda.datetime);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.secondarySurface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReminderContent(
              type: agenda.category,
              title: agenda.content1,
              dose: agenda.content2.isNotEmpty ? agenda.content2 : null,
            ),
            const SizedBox(height: 24),
            Text(
              "Waktu: ${_getTimeString()}",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                MainButton(
                  buttonText: "Sudah",
                  onTap: () {
                    onCompleted(agenda.agendaId);
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 16),
                MainButton(
                  buttonText: "Abaikan",
                  color: AppColors.neutral40,
                  onTap: () {
                    onDismissed();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
