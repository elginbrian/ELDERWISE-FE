import 'package:flutter/material.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';

class BuildAgenda extends StatelessWidget {
  final String type;
  final String nama;
  final String dose;
  final String time;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BuildAgenda({
    super.key,
    required this.type,
    required this.nama,
    required this.dose,
    required this.time,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    String iconFile;
    switch (type.toLowerCase()) {
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
        iconFile = 'default.png';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.secondarySurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(iconImages + iconFile),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    color: AppColors.neutral80,
                  ),
                ),
                Row(
                  children: [
                    if (nama.isNotEmpty)
                      Flexible(
                        child: Text(
                          nama,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: AppColors.neutral90,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(width: 8),
                    if (dose.isNotEmpty)
                      Text(
                        ("(" + dose + ")"),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          color: AppColors.neutral70,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(image: AssetImage(iconImages + 'clock2.png'), width: 12,),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        color: AppColors.neutral80,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onEdit != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: onEdit,
              ),
            ),
        ],
      ),
    );
  }
}
