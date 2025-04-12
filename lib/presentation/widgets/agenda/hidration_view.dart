
import 'package:elderwise/presentation/widgets/agenda/time_picker.dart';
import 'package:elderwise/presentation/widgets/profile/custom_profile_field.dart';
import 'package:flutter/material.dart';
class HidrationView extends StatelessWidget {
  const HidrationView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomProfileField(
          title: 'Nama Minuman',
          hintText: 'Nama Minuman',
          icon: Icons.local_drink,
        ),
        CustomProfileField(
          title: 'Jumlah air',
          hintText: 'Jumlah Air yang Diminum',
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
