import 'package:elderwise/data/api/requests/agenda_request.dart';
import 'package:elderwise/domain/entities/agenda.dart';
import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_bloc.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_event.dart';
import 'package:elderwise/presentation/bloc/user_mode/user_mode_bloc.dart';
import 'package:elderwise/presentation/screens/agenda_screen/add_agenda.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AgendaListItem extends StatefulWidget {
  final Agenda agenda;
  final Function() onAgendaUpdated;

  const AgendaListItem({
    Key? key,
    required this.agenda,
    required this.onAgendaUpdated,
  }) : super(key: key);

  @override
  State<AgendaListItem> createState() => _AgendaListItemState();
}

class _AgendaListItemState extends State<AgendaListItem> {
  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm').format(widget.agenda.datetime);

    // Get current user mode
    final userMode = context.watch<UserModeBloc>().state.userMode;
    final isElderMode = userMode == UserMode.elder;

    return Dismissible(
      // Only allow dismissal if not in elder mode
      key: Key(widget.agenda.agendaId),
      direction:
          isElderMode ? DismissDirection.none : DismissDirection.endToStart,
      confirmDismiss: (direction) => _confirmDelete(context),
      onDismissed: (direction) {
        context
            .read<AgendaBloc>()
            .add(DeleteAgendaEvent(widget.agenda.agendaId));
        widget.onAgendaUpdated();
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: _buildLeadingIcon(
              widget.agenda.category, widget.agenda.isFinished),
          title: Text(
            widget.agenda.content1,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: AppColors.neutral90,
              decoration: widget.agenda.isFinished
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.agenda.content2 != null &&
                  widget.agenda.content2!.isNotEmpty)
                Text(
                  widget.agenda.content2!,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: AppColors.neutral70,
                    decoration: widget.agenda.isFinished
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
                  decoration: widget.agenda.isFinished
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ],
          ),
          trailing: isElderMode
              ? _buildElderModeTrailing(context)
              : _buildCaregiverModeTrailingWithoutDelete(context),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(String category, bool isFinished) {
    String iconFile;

    // Match the same logic as in BuildAgenda for choosing icon files
    switch (category.toLowerCase()) {
      case 'obat':
        iconFile = 'medicine.png';
        break;
      case 'makan':
      case 'makanan':
        iconFile = 'food.png';
        break;
      case 'hidrasi':
        iconFile = 'hidration.png';
        break;
      case 'aktivitas':
        iconFile = 'activity.png';
        break;
      default:
        iconFile = 'default.png';
    }

    // Keep container size reasonable but maximize image size within
    return Container(
      width: 60, // Maintain a reasonable container size
      height: 60, // Maintain a reasonable container size
      padding:
          const EdgeInsets.all(0), // Remove padding to maximize image space
      child: Image.asset(
        iconImages + iconFile,
        width: 60, // Make image fill container
        height: 60, // Make image fill container
        fit: BoxFit.contain, // Ensure the image fits properly
      ),
    );
  }

  Widget _buildElderModeTrailing(BuildContext context) {
    return IconButton(
      icon: Icon(
        widget.agenda.isFinished
            ? Icons.check_circle
            : Icons.check_circle_outline,
        color: widget.agenda.isFinished
            ? AppColors.primaryMain
            : AppColors.neutral50,
        size: 30, // Larger icon for better visibility
      ),
      onPressed: () => _toggleAgendaStatus(context),
      tooltip:
          widget.agenda.isFinished ? 'Tandai belum selesai' : 'Tandai selesai',
    );
  }

  // Modified to remove the delete button since we're using swipe instead
  Widget _buildCaregiverModeTrailingWithoutDelete(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            widget.agenda.isFinished
                ? Icons.check_circle
                : Icons.check_circle_outline,
            color: widget.agenda.isFinished
                ? AppColors.primaryMain
                : AppColors.neutral50,
          ),
          onPressed: () => _toggleAgendaStatus(context),
        ),
        IconButton(
          icon: const Icon(
            Icons.edit_outlined,
            color: AppColors.neutral50,
          ),
          onPressed: () => _editAgenda(context),
        ),
      ],
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final userMode = context.read<UserModeBloc>().state.userMode;
    final isElderMode = userMode == UserMode.elder;

    // Don't allow deletion in elder mode
    if (isElderMode) return false;

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content:
                const Text('Apakah Anda yakin ingin menghapus agenda ini?'),
            actions: [
              TextButton(
                child: const Text('Batal'),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text('Hapus'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _toggleAgendaStatus(BuildContext context) {
    final updatedAgendaDto = AgendaRequestDTO(
      elderId: widget.agenda.elderId,
      caregiverId: widget.agenda.caregiverId,
      category: widget.agenda.category,
      content1: widget.agenda.content1,
      content2: widget.agenda.content2,
      datetime: widget.agenda.datetime.toIso8601String(),
      isFinished: !widget.agenda.isFinished,
    );

    context.read<AgendaBloc>().add(UpdateAgendaEvent(
          widget.agenda.agendaId,
          updatedAgendaDto,
        ));

    widget.onAgendaUpdated();
  }

  void _editAgenda(BuildContext context) {
    final userMode = context.read<UserModeBloc>().state.userMode;
    final isElderMode = userMode == UserMode.elder;

    // Don't allow editing in elder mode
    if (isElderMode) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAgenda(
          agendaId: widget.agenda.agendaId,
          category: widget.agenda.category,
          content1: widget.agenda.content1,
          content2: widget.agenda.content2,
          timeStr:
              '${widget.agenda.datetime.hour}:${widget.agenda.datetime.minute}',
        ),
      ),
    ).then((result) {
      if (result == true) {
        widget.onAgendaUpdated();
      }
    });
  }

  IconData _getIconForCategory(String category) {
    // This method can be kept for backward compatibility
    // and for use with any UI elements that still need IconData
    switch (category.toLowerCase()) {
      case 'obat':
        return Icons.medication;
      case 'makanan':
      case 'makan':
        return Icons.restaurant;
      case 'aktivitas':
        return Icons.directions_run;
      default:
        return Icons.event_note;
    }
  }
}
