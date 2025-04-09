import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/agenda/build_agenda.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  DateTime selectedDate = DateTime(2025, 3, 26);
  final TextEditingController dateController = TextEditingController();
  final List<String> weekdays = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      setState(() {
        dateController.text =
            DateFormat('yyyy-MM-dd', 'id_ID').format(selectedDate);
      });
    });
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  void updateDateUI() {
    setState(() {});
  }

  void onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      updateDateUI();
    });
  }

  List<DateTime> getDaysInWeek() {
    final DateTime monday =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    return List.generate(6, (index) => monday.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final daysInWeek = getDaysInWeek();

    return Scaffold(
      backgroundColor: AppColors.primaryMain,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios, color: AppColors.neutral90),
                  const SizedBox(width: 32),
                  const Text(
                    'Agenda',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: AppColors.neutral90,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(32.0),
                decoration: const BoxDecoration(
                  color: AppColors.secondarySurface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondarySurface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: AppColors.primaryMain,
                                        onPrimary: AppColors.neutral90,
                                        onSurface: AppColors.neutral90,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (picked != null) {
                                setState(() {
                                  selectedDate = picked;
                                  updateDateUI();
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                                      .format(selectedDate),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      fontFamily: 'Poppins'),
                                ),
                                const Spacer(),
                                const Icon(Icons.keyboard_arrow_down,
                                    color: AppColors.neutral90),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              itemCount: daysInWeek.length,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final day = daysInWeek[index];
                                final isSelected =
                                    day.day == selectedDate.day &&
                                        day.month == selectedDate.month;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedDate = day;
                                      });
                                    },
                                    child: Container(
                                      width: 50,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${day.day}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                color: AppColors.neutral90),
                                          ),
                                          Text(
                                            weekdays[day.weekday - 1],
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                color: AppColors.neutral90),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    const Text(
                      'Agenda',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        color: AppColors.neutral90,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: const [
                          BuildAgenda(
                            type: 'Obat',
                            nama: 'Paracetamol',
                            dose: '500mg',
                            time: '08:00',
                          ),
                          BuildAgenda(
                            type: 'Makan',
                            nama: 'Nasi Goreng',
                            dose: '',
                            time: '12:00',
                          ),
                          BuildAgenda(
                            type: 'Hidrasi',
                            nama: 'Air Mineral',
                            dose: '250ml',
                            time: '10:00',
                          ),
                          BuildAgenda(
                            type: 'Aktivitas',
                            nama: 'Senam Pagi',
                            dose: '',
                            time: '06:30',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primaryMain,
            borderRadius: BorderRadius.circular(32),
          ),
          child: const Icon(Icons.add, color: AppColors.neutral90),
        ),
      ),
    );
  }
}
