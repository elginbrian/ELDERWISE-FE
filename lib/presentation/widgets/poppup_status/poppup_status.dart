import 'package:flutter/material.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';

class PopupStatus extends StatelessWidget {
  final String status;
  final String type;

  const PopupStatus({
    super.key,
    required this.status,
    required this.type,
  });

  @override
Widget build(BuildContext context) {
  String secondText = '';

  if (status == 'success') {
    switch (type) {
      case 'agenda':
        secondText = 'Agenda ditambahkan';
        break;
      case 'area':
        secondText = 'Area ditambahkan';
        break;
      case 'profil':
        secondText = 'Profil disimpan';
        break;
      default:
        secondText = '';
    }
  } else if (status == 'failed') {
    switch (type) {
      case 'agenda':
        secondText = 'Gagal menambahkan agenda';
        break;
      case 'area':
        secondText = 'Gagal menambahkan area';
        break;
      case 'profil':
        secondText = 'Gagal menyimpan profil';
        break;
      default:
        secondText = '';
    }
  }

  final bool isSuccess = status == 'success';
  final String image = isSuccess ? 'success.png' : 'failed.png';
  final String mainText = isSuccess ? 'Berhasil!' : 'Gagal!';

  return Center(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      width: 224,
      height: 305,
      decoration: BoxDecoration(
        color: AppColors.secondarySurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            spreadRadius: 2,
            color: AppColors.neutral100.withOpacity(0.05),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(iconImages + image, width: 115),
          Column(
            children: [
              Text(
                mainText,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral90,
                ),
              ),
              Text(
                secondText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral90,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MainButton(buttonText: "Selesai"),
          ),
        ],
      ),
    ),
  );
}

}
