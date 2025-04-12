import 'package:flutter/material.dart';
import 'package:elderwise/presentation/widgets/agenda/styled_text_field.dart';
import 'package:elderwise/presentation/widgets/agenda/date_picker_field.dart';
import 'package:elderwise/presentation/widgets/agenda/time_picker.dart';

class AgendaFormSection extends StatelessWidget {
  final String type;
  final TextEditingController nameController;
  final TextEditingController amountController;
  final DateTime selectedDate;
  final TimeOfDay? selectedTime;
  final Function(DateTime) onDateSelected;
  final Function(TimeOfDay) onTimeSelected;

  const AgendaFormSection({
    Key? key,
    required this.type,
    required this.nameController,
    required this.amountController,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateSelected,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'Makan':
        return Column(
          children: [
            StyledTextField(
              controller: nameController,
              title: 'Nama Makanan',
              hintText: 'Masukkan nama makanan',
              icon: Icons.fastfood_rounded,
              validator: (value) => value == null || value.isEmpty
                  ? 'Nama makanan tidak boleh kosong'
                  : null,
            ),
            StyledTextField(
              controller: amountController,
              title: 'Jumlah Porsi',
              hintText: 'Masukkan jumlah porsi',
              icon: Icons.numbers,
            ),
            DatePickerField(
              selectedDate: selectedDate,
              onDateSelected: onDateSelected,
            ),
            TimePicker(
              title: "Waktu",
              hintText: "Pilih waktu",
              initialTime: selectedTime,
              icon: Icons.access_time,
              onTimeSelected: onTimeSelected,
            ),
          ],
        );
      case 'Hidrasi':
        return Column(
          children: [
            StyledTextField(
              controller: nameController,
              title: 'Nama Minuman',
              hintText: 'Masukkan nama minuman',
              icon: Icons.local_drink,
              validator: (value) => value == null || value.isEmpty
                  ? 'Nama minuman tidak boleh kosong'
                  : null,
            ),
            StyledTextField(
              controller: amountController,
              title: 'Jumlah Air',
              hintText: 'Masukkan jumlah air (ml)',
              icon: Icons.numbers,
            ),
            DatePickerField(
              selectedDate: selectedDate,
              onDateSelected: onDateSelected,
            ),
            TimePicker(
              title: "Waktu",
              hintText: "Pilih waktu",
              initialTime: selectedTime,
              icon: Icons.access_time,
              onTimeSelected: onTimeSelected,
            ),
          ],
        );
      case 'Obat':
        return Column(
          children: [
            StyledTextField(
              controller: nameController,
              title: 'Nama Obat',
              hintText: 'Masukkan nama obat',
              icon: Icons.medication_rounded,
              validator: (value) => value == null || value.isEmpty
                  ? 'Nama obat tidak boleh kosong'
                  : null,
            ),
            StyledTextField(
              controller: amountController,
              title: 'Dosis Obat',
              hintText: 'Masukkan dosis obat',
              icon: Icons.numbers,
            ),
            DatePickerField(
              selectedDate: selectedDate,
              onDateSelected: onDateSelected,
            ),
            TimePicker(
              title: "Waktu",
              hintText: "Pilih waktu",
              initialTime: selectedTime,
              icon: Icons.access_time,
              onTimeSelected: onTimeSelected,
            ),
          ],
        );
      default:
        return Column(
          children: [
            StyledTextField(
              controller: nameController,
              title: 'Nama Aktivitas',
              hintText: 'Masukkan nama aktivitas',
              icon: Icons.local_activity,
              validator: (value) => value == null || value.isEmpty
                  ? 'Nama aktivitas tidak boleh kosong'
                  : null,
            ),
            StyledTextField(
              controller: amountController,
              title: 'Deskripsi',
              hintText: 'Masukkan deskripsi aktivitas',
              icon: Icons.description,
            ),
            DatePickerField(
              selectedDate: selectedDate,
              onDateSelected: onDateSelected,
            ),
            TimePicker(
              title: "Waktu",
              hintText: "Pilih waktu",
              initialTime: selectedTime,
              icon: Icons.access_time,
              onTimeSelected: onTimeSelected,
            ),
          ],
        );
    }
  }
}
