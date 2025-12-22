import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nammastore_rider/controller/onboarding_controller.dart';
import 'package:nammastore_rider/models/onboarding_model.dart';
import 'package:nammastore_rider/routes/app_pages.dart';

class OnboardingCategoryDocsScreen extends GetView<OnboardingController> {
  const OnboardingCategoryDocsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get category from arguments
    final DocCategory category = Get.arguments as DocCategory;

    String title = _getCategoryTitle(category);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        final docs = controller.documents
            .where((doc) => doc.category == category)
            .toList();

        if (controller.isLoading.value && docs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: ListTile(
                title: Text(
                  doc.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  doc.status == DocStatus.uploaded
                      ? Icons.check_circle
                      : Icons.arrow_forward_ios,
                  color: doc.status == DocStatus.uploaded
                      ? Colors.green
                      : Colors.grey,
                  size: 20,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                onTap: () {
                  Get.toNamed(Routes.onboardingUploadDoc, arguments: doc.id);
                },
              ),
            );
          },
        );
      }),
    );
  }

  String _getCategoryTitle(DocCategory category) {
    switch (category) {
      case DocCategory.personal:
        return 'Personal Documents';
      case DocCategory.vehicle:
        return 'Vehicle Details';
      case DocCategory.bank:
        return 'Bank Account Details';
      case DocCategory.emergency:
        return 'Emergency Details';
    }
  }
}
