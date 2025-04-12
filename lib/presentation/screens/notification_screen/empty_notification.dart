import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class EmptyNotification extends StatelessWidget {
  const EmptyNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(image: AssetImage(iconImages + 'mute.png'), width: 96,),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8),
          child: Text("Tidak ada notfikasi", style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.neutral70
          ),),
        ),
        Text("Notifikasi Anda akan muncul setelah Anda menerimanya", style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.neutral70
        ),),
        SizedBox(height: 72,)
      ],
    );
  }
}