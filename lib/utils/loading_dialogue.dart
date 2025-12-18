import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nammastore_rider/widgets/bouncing_image_loader.dart';

void showLoadingDialog() {
  if (!(Get.isDialogOpen ?? false)) {
    Get.dialog(
      PopScope(
        canPop: false,
        child: const Center(child: BouncingImageLoader()),
      ),
      barrierDismissible: false,
    );
  }
}
