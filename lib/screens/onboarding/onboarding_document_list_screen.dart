import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nammastore_rider/controller/onboarding_controller.dart';
import 'package:nammastore_rider/models/onboarding_model.dart';
import 'package:nammastore_rider/routes/app_pages.dart';

class OnboardingDocumentListScreen extends GetView<OnboardingController> {
  const OnboardingDocumentListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Header ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60,
                left: 20,
                right: 20,
                bottom: 30,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF8A80), Color(0xFFFF5252)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome to Nammastore", // User said "EatFit" in image but app is Nammastore. Using App Name.
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Just a few steps to complete and then you\ncan start earning with Us",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Obx(() {
              // Calculate status
              final isPersonalDocsDone = controller.isCategoryCompleted(
                DocCategory.personal,
              );
              final isVehicleDocsDone = controller.isCategoryCompleted(
                DocCategory.vehicle,
              );
              final isBankDocsDone = controller.isCategoryCompleted(
                DocCategory.bank,
              );
              // Emergency: Placeholder for now, assume pending or separate logic.
              // Letting Emergency be a placeholder that is always pending or requires explicit implementation
              // For now, let's treat it as a placeholder.

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Pending Documents ---
                    if (!isPersonalDocsDone ||
                        !isVehicleDocsDone ||
                        !isBankDocsDone) ...[
                      const Text(
                        "Pending Documents",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (!isPersonalDocsDone)
                        _buildCategoryTile(
                          "Personal Documents",
                          () => Get.toNamed(
                            Routes.onboardingCategoryDocs,
                            arguments: DocCategory.personal,
                          ),
                        ),
                      if (!isVehicleDocsDone)
                        _buildCategoryTile(
                          "Vehicle Details",
                          () => Get.toNamed(
                            Routes.onboardingCategoryDocs,
                            arguments: DocCategory.vehicle,
                          ),
                        ),
                      if (!isBankDocsDone)
                        _buildCategoryTile(
                          "Bank Account Details",
                          () => Get.toNamed(
                            Routes.onboardingCategoryDocs,
                            arguments: DocCategory.bank,
                          ),
                        ),
                      // Always show Emergency as pending/option until implemented
                      _buildCategoryTile("Emergency Details", () {
                        // TODO: Implement Emergency Details Screen
                        Get.snackbar("Coming Soon", "Emergency Details form");
                      }),
                      const SizedBox(height: 20),
                    ],

                    // --- Completed Documents ---
                    const Text(
                      "Completed Documents",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildCompletedTile("Personal Information"),
                    if (isPersonalDocsDone)
                      _buildCompletedTile(
                        "Personal Documents",
                        onTap: () => Get.toNamed(
                          Routes.onboardingCategoryDocs,
                          arguments: DocCategory.personal,
                        ),
                      ),
                    if (isVehicleDocsDone)
                      _buildCompletedTile(
                        "Vehicle Details",
                        onTap: () => Get.toNamed(
                          Routes.onboardingCategoryDocs,
                          arguments: DocCategory.vehicle,
                        ),
                      ),
                    if (isBankDocsDone)
                      _buildCompletedTile(
                        "Bank Account Details",
                        onTap: () => Get.toNamed(
                          Routes.onboardingCategoryDocs,
                          arguments: DocCategory.bank,
                        ),
                      ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.submitAllDocuments(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8A80),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile(String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 15)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildCompletedTile(String title, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        leading: const Icon(Icons.check, color: Colors.black, size: 20),
        trailing: onTap != null
            ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
            : null,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
