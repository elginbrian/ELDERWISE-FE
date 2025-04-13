import 'package:flutter/material.dart';
import 'package:elderwise/presentation/themes/colors.dart';

class ToastHelper {
  static void showSuccessToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryMain,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showErrorToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void showLoadingToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.neutral80,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 30),
      ),
    );
  }

  static String getUserFriendlyErrorMessage(String error) {
    if (error.contains('DioException') ||
        error.contains('SocketException') ||
        error.contains('HttpException')) {
      return 'Koneksi bermasalah. Silakan periksa internet Anda.';
    } else if (error.contains('timeout')) {
      return 'Waktu permintaan habis. Silakan coba lagi.';
    } else if (error.contains('Not Found') || error.contains('404')) {
      return 'Data tidak ditemukan.';
    } else if (error.contains('Unauthorized') || error.contains('401')) {
      return 'Sesi Anda telah berakhir. Silakan login kembali.';
    } else if (error.contains('FormatException')) {
      return 'Format data tidak sesuai. Silakan coba lagi.';
    } else if (error.toLowerCase().contains('validation')) {
      return 'Data yang Anda masukkan tidak valid.';
    } else {
      return 'Terjadi kesalahan. Silakan coba lagi nanti.';
    }
  }
}
