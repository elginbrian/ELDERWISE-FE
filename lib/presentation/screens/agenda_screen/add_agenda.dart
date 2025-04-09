import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/agenda/activity_view.dart';
import 'package:elderwise/presentation/widgets/agenda/agenda_selector.dart';
import 'package:elderwise/presentation/widgets/agenda/food_view.dart';
import 'package:elderwise/presentation/widgets/agenda/hidration_view.dart';
import 'package:elderwise/presentation/widgets/agenda/medicine_view.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:elderwise/presentation/widgets/profile/custom_profile_field.dart';
import 'package:flutter/material.dart';

class AddAgenda extends StatefulWidget {
  const AddAgenda({super.key});

  @override
  State<AddAgenda> createState() => _AddAgendaState();
}

class _AddAgendaState extends State<AddAgenda> {
  String? selectedAgenda = "Obat";

  Widget? _getAgendaView(String? agenda) {
    switch (agenda) {
      case 'Makan':
        return const FoodView();
      case 'Hidrasi':
        return const HidrationView();
      case 'Obat':
        return const MedicineView();
      default:
        return const ActivityView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondarySurface,
      appBar: AppBar(
        title: const Text("Tambah Agenda"),
        leading: const Icon(Icons.arrow_back_ios),
        backgroundColor: AppColors.secondarySurface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                AgendaTypeDropdown(
                  selectedValue: selectedAgenda,
                  onChanged: (value) {
                    setState(() {
                      selectedAgenda = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (selectedAgenda != null) _getAgendaView(selectedAgenda)!,
              ],
            ),
            MainButton(buttonText: "Tambah Agenda", onTap: () {})
          ],
        ),
      ),
    );
  }
}
