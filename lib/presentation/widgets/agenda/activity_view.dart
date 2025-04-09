
import 'package:elderwise/presentation/widgets/agenda/time_picker.dart';
import 'package:elderwise/presentation/widgets/profile/custom_profile_field.dart';
import 'package:flutter/material.dart';
class ActivityView extends StatelessWidget {
  const ActivityView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomProfileField(
          title: 'Nama Obat',
          hintText: 'Nama Obat',
          icon: Icons.local_activity,
        ),
        CustomProfileField(
          title: 'Deskripsi',
          hintText: 'Deskripsi Aktivitas',
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
