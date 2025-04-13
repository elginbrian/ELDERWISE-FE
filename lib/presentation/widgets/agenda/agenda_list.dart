import 'package:flutter/material.dart';
import 'package:elderwise/domain/entities/agenda.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/agenda/agenda_list_item.dart';

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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryMain,
        ),
      );
    }

    if (agendas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.event_available,
              size: 64,
              color: AppColors.neutral60,
            ),
            SizedBox(height: 16),
            Text(
              'Tidak ada agenda pada tanggal ini',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: AppColors.neutral60,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: agendas.length,
      itemBuilder: (context, index) {
        final agenda = agendas[index];
        return AgendaListItem(
          agenda: agenda,
          onAgendaUpdated: onAgendaUpdated,
        );
      },
    );
  }
}
