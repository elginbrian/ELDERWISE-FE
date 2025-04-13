import 'package:elderwise/domain/entities/agenda.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/homescreen/elder_agenda_item.dart';
import 'package:flutter/material.dart';

class ElderAgendaSection extends StatelessWidget {
  final List<Agenda> agendas;
  final VoidCallback onSeeAllTap;

  const ElderAgendaSection({
    Key? key,
    required this.agendas,
    required this.onSeeAllTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 128),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(iconImages + 'agenda.png'),
                  const SizedBox(width: 4),
                  const Text(
                    "Agenda Terdekat",
                    style: TextStyle(
                      color: AppColors.neutral90,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              TextButton(
                onPressed: onSeeAllTap,
                child: const Text(
                  "Lihat Semua",
                  style: TextStyle(
                    color: AppColors.neutral90,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: agendas.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada agenda untuk saat ini",
                    style: TextStyle(
                      color: AppColors.neutral70,
                      fontFamily: 'Poppins',
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: agendas.length > 1 ? 1 : agendas.length,
                  itemBuilder: (context, index) {
                    return ElderAgendaItem(agenda: agendas[index]);
                  },
                ),
        ),
      ],
    );
  }
}
