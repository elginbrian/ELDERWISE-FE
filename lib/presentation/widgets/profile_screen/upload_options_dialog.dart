import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/utils/toast_helper.dart';
import 'package:flutter/material.dart';

enum UploadOption { now, later }

class UploadOptionsDialog {
  static Future<UploadOption?> show(
      BuildContext context, String entityType) async {
    UploadOption? result;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColors.neutral20,
        title: Text(
          "Unggah Foto Profil",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: AppColors.neutral90,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          "Apakah Anda ingin mengunggah foto profil sekarang atau menyimpannya bersama perubahan profil lainnya?",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
            color: AppColors.neutral80,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primaryMain,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: Size(double.infinity, 48),
                  ),
                  onPressed: () {
                    result = UploadOption.now;
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Unggah Sekarang",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.secondarySurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: Size(double.infinity, 48),
                  ),
                  onPressed: () {
                    result = UploadOption.later;
                    Navigator.of(context).pop();
                    ToastHelper.showSuccessToast(context,
                        'Foto profil akan diunggah saat menyimpan perubahan');
                  },
                  child: Text(
                    "Simpan dengan Profil",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: AppColors.neutral90,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return result;
  }
}
