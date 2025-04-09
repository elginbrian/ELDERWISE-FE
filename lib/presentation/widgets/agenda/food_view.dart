
import 'package:elderwise/presentation/widgets/agenda/time_picker.dart';
import 'package:elderwise/presentation/widgets/profile/custom_profile_field.dart';
import 'package:flutter/material.dart';
class FoodView extends StatelessWidget {
  const FoodView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomProfileField(
          title: 'Nama Makanan',
          hintText: 'Nama Makanan',
          icon: Icons.fastfood_rounded,
        ),
        CustomProfileField(
          title: 'Jumlah Porsi',
          hintText: 'Jumlah porsi makanan',
          icon: Icons.numbers,
        ),
        TimePicker(
          title: "Waktu",
          hintText: "Pilih waktu",
          icon: Icons.access_time,
          onTimeSelected: (TimeOfDay time) {
            print("Waktu yang dipilih: ${time.format(context)}");
          },
        ),
      ],
    );
  }
}
