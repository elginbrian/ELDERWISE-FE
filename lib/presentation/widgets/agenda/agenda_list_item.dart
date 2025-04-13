import 'package:elderwise/data/api/requests/agenda_request.dart';
import 'package:elderwise/domain/entities/agenda.dart';
import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_bloc.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_event.dart';
import 'package:elderwise/presentation/bloc/user_mode/user_mode_bloc.dart';
import 'package:elderwise/presentation/screens/agenda_screen/add_agenda.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AgendaListItem extends StatelessWidget {
  final Agenda agenda;
  final Function() onAgendaUpdated;

  const AgendaListItem({
    Key? key,
    required this.agenda,
    required this.onAgendaUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userModeState = context.watch<UserModeBloc>().state;
    final isElderMode = userModeState.userMode == UserMode.elder;

    // Format time to display
    final time = DateFormat('HH:mm').format(agenda.datetime);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: agenda.isFinished
              ? AppColors.primaryMain
              : AppColors.primaryMain.withOpacity(0.1),
          child: Icon(
            _getIconForCategory(agenda.category),
            color: agenda.isFinished ? Colors.white : AppColors.primaryMain,
          ),
        ),
        title: Text(
          agenda.content1,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: AppColors.neutral90,
            decoration: agenda.isFinished
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (agenda.content2 != null && agenda.content2!.isNotEmpty)
              Text(
                agenda.content2!,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: AppColors.neutral70,
                  decoration: agenda.isFinished
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            Text(
              'Pukul $time',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                color: AppColors.neutral60,
                decoration: agenda.isFinished
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Check button - available for elders too
            IconButton(
              icon: Icon(
                agenda.isFinished
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                color: agenda.isFinished
                    ? AppColors.primaryMain
                    : AppColors.neutral50,
              ),
              onPressed: () {
                _toggleAgendaStatus(context);
              },
            ),

            // Edit and delete - only for caregivers
            if (!isElderMode) ...[
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.neutral50,
                ),
                onPressed: () => _editAgenda(context),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.neutral50,
                ),
                onPressed: () => _deleteAgenda(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _toggleAgendaStatus(BuildContext context) {
    final updatedAgendaDto = AgendaRequestDTO(
      elderId: agenda.elderId,
      caregiverId: agenda.caregiverId,
      category: agenda.category,
      content1: agenda.content1,
      content2: agenda.content2,
      datetime: agenda.datetime.toIso8601String(),
      isFinished: !agenda.isFinished,
    );

    context.read<AgendaBloc>().add(UpdateAgendaEvent(
          agenda.agendaId,
          updatedAgendaDto,
        ));

    onAgendaUpdated();
  }

  void _editAgenda(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAgenda(
          agendaId: agenda.agendaId,
          category: agenda.category,
          content1: agenda.content1,
          content2: agenda.content2,
          timeStr: '${agenda.datetime.hour}:${agenda.datetime.minute}',
        ),
      ),
    ).then((result) {
      if (result == true) {
        onAgendaUpdated();
      }
    });
  }

  void _deleteAgenda(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin menghapus agenda ini?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Hapus'),
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<AgendaBloc>()
                  .add(DeleteAgendaEvent(agenda.agendaId));
              onAgendaUpdated();
            },
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'obat':
        return Icons.medication;
      case 'makanan':
        return Icons.restaurant;
      case 'aktivitas':
        return Icons.directions_run;
      default:
        return Icons.event_note;
    }
  }
}
