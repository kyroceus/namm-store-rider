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
      appBar: AppBar(
        title: const Text("Personal Documents"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Static Personal Info Status
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 5,
              ),
              child: const Card(
                elevation: 2,
                child: ListTile(
                  title: Text("Personal Information"),
                  trailing: Icon(Icons.check_circle, color: Colors.green),
                ),
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.documents.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.documents.length,
                  itemBuilder: (context, index) {
                    final doc = controller.documents[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 15),
                      child: ListTile(
                        title: Text(doc.title),
                        trailing: Icon(
                          doc.status == DocStatus.uploaded
                              ? Icons.check_circle
                              : Icons.arrow_forward_ios,
                          color: doc.status == DocStatus.uploaded
                              ? Colors.green
                              : Colors.grey,
                        ),
                        // Navigate to upload screen for this document
                        onTap: () {
                          Get.toNamed(
                            Routes.onboardingUploadDoc,
                            arguments: doc.id,
                          );
                        },
                      ),
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.submitAllDocuments(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Submit"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
