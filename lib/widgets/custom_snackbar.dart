import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nammastore_rider/consts/app_colors.dart';

void showCustomSnackBar({
  required String title,
  required String message,
  required SnackBarType snackBarType,
}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(
          snackBarType == SnackBarType.success
              ? Icons.check_circle_outline
              : snackBarType == SnackBarType.error
              ? Icons.error_outline
              : Icons.info_outline,
          color: AppColors.background1,
          size: 16,
        ),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: AppColors.background1, fontSize: 16),
          ),
        ),
      ],
    ),
    backgroundColor: AppColors.textSecondary,

    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(16),
    duration: Duration(milliseconds: 2500),
    elevation: 6,
  );

  Get.snackbar(
    '',
    '',
    titleText: Text(
      title,
      style: TextStyle(
        color: AppColors.background1,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ), // Empty title to avoid showing a title
    messageText: snackBar.content,
    animationDuration: const Duration(milliseconds: 300),

    backgroundColor: snackBar.backgroundColor!.withValues(alpha: 0.8),
    snackPosition: SnackPosition.TOP,
    duration: snackBar.duration,
    borderRadius: 12,
    isDismissible: true,
    barBlur: 200,
  );
}

enum SnackBarType { success, error, info }
