import 'package:elderwise/domain/entities/agenda.dart';
import 'package:elderwise/presentation/screens/agenda_screen/agenda_page.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AgendaListSection extends StatelessWidget {
  final List<Agenda> agendas;

  const AgendaListSection({
    Key? key,
    required this.agendas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(iconImages + 'agenda.png'),
                  const SizedBox(width: 4),
                  const Text(
                    "Agenda",
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
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AgendaPage()),
                  );
                },
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
        SizedBox(
          height: 128,
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
                  scrollDirection: Axis.horizontal,
                  itemCount: agendas.length > 5 ? 5 : agendas.length,
                  itemBuilder: (context, index) {
                    return _buildAgendaItem(agendas[index]);
                  },
                ),
        )
      ],
    );
  }

  Widget _buildAgendaItem(Agenda agenda) {
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

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        width: 72,
        height: 128,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.secondarySurface,
          boxShadow: const [
            BoxShadow(
              blurRadius: 3,
              color: AppColors.neutral30,
              spreadRadius: 0,
              offset: Offset(1, 3),
            )
          ],
        ),
        child: Column(
          children: [
            Image.asset(iconImages + iconFile),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    agenda.category[0].toUpperCase() +
                        agenda.category.substring(1).toLowerCase(),
                    style: const TextStyle(
                      color: AppColors.neutral90,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Image.asset(iconImages + 'clock2.png'),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: AppColors.neutral90,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
