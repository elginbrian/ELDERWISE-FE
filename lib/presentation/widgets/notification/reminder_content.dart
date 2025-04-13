import 'package:flutter/material.dart';

class ReminderContent extends StatelessWidget {
  final String type;
  final String title;
  final String? dose;

  const ReminderContent({
    super.key,
    required this.type,
    required this.title,
    this.dose,
  });

  String get theType {
    switch (type.toLowerCase()) {
      case 'makan':
        return 'Makan';
      case 'hidrasi':
        return 'Minum';
      case 'obat':
        return 'Minum Obat';
      case 'aktivitas':
        return 'beraktivitas';
      default:
        return 'Minum Obat';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("lib/presentation/screens/assets/images/illust1.png"),
          Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 8),
            child: Text(
              "Saatnya $theType!", textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          dose != null
              ? Text(
                  dose!,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
