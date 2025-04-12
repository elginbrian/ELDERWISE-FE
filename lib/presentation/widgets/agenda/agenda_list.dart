import 'package:flutter/material.dart';
import 'package:elderwise/domain/entities/agenda.dart';
import 'package:elderwise/presentation/widgets/agenda/build_agenda.dart';
import 'package:elderwise/presentation/widgets/agenda/empty_agenda_view.dart';
import 'package:elderwise/presentation/screens/agenda_screen/add_agenda.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_bloc.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgendaList extends StatelessWidget {
  final List<Agenda> agendas;
  final bool isLoading;
  final Function() onAgendaUpdated;

  const AgendaList({
    Key? key,
    required this.agendas,
    required this.isLoading,
    required this.onAgendaUpdated,
  }) : super(key: key);

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (agendas.isEmpty) {
      return const EmptyAgendaView();
    }

    return ListView.builder(
      itemCount: agendas.length,
      itemBuilder: (context, index) {
        final agenda = agendas[index];
        return Dismissible(
          key: Key(agenda.agendaId),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            final result = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Hapus Agenda'),
                content:
                    const Text('Apakah Anda yakin ingin menghapus agenda ini?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Hapus'),
                  ),
                ],
              ),
            );
            if (result == true) {
              context
                  .read<AgendaBloc>()
                  .add(DeleteAgendaEvent(agenda.agendaId));
            }
            return result;
          },
          child: GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAgenda(
                    agendaId: agenda.agendaId,
                    category: agenda.category,
                    content1: agenda.content1,
                    content2: agenda.content2,
                    timeStr: _formatTime(agenda.datetime),
                  ),
                ),
              );
              if (result == true) {
                onAgendaUpdated();
              }
            },
            child: BuildAgenda(
              type: agenda.category,
              nama: agenda.content1,
              dose: agenda.content2,
              time: _formatTime(agenda.datetime),
            ),
          ),
        );
      },
    );
  }
}
