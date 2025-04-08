import 'package:flutter/material.dart';
import 'package:elderwise/presentation/themes/colors.dart';

class ToastHelper {
  static void showSuccessToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColors.neutral100),
        ),
        backgroundColor: AppColors.primaryMain,
      ),
    );
  }

  static void showErrorToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColors.neutral100),
        ),
        backgroundColor: Colors.red,
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
