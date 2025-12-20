import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nammastore_rider/controller/onboarding_controller.dart';
import 'package:nammastore_rider/models/onboarding_model.dart';

class OnboardingUploadDocScreen extends GetView<OnboardingController> {
  const OnboardingUploadDocScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final docId = Get.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          // efficient lookup or safe fallback
          final title = controller.documents
              .firstWhere(
                (e) => e.id == docId,
                orElse: () => DocumentModel(id: '0', title: ''),
              )
              .title;
          return Text("$title details");
        }),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        // Re-fetch doc from controller to get updated status/path
        final doc = controller.documents.firstWhere(
          (e) => e.id == docId,
          orElse: () => DocumentModel(id: '0', title: 'Unknown'),
        );

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text("Front side photo of your ${doc.title}"),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _showPicker(context, docId),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                    image: doc.frontImage != null && doc.frontImage!.isNotEmpty
                        ? DecorationImage(
                            image: doc.frontImage!.startsWith('http')
                                ? NetworkImage(doc.frontImage!)
                                : FileImage(File(doc.frontImage!))
                                      as ImageProvider,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: doc.frontImage != null
                      ? null // Image is shown in decoration
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 40,
                                color: Colors.red,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Upload Photo",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                ),
              ),

              if (doc.frontImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Tap to change",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: doc.frontImage == null
                      ? null // Disable if no image
                      : () {
                          Get.back(); // Just go back, image is "uploaded" on selection in our logic
                          // Or call a final confirm method if needed
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Confirm & Submit"),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  void _showPicker(BuildContext context, String docId) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                controller.pickDocImage(docId, isCamera: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                controller.pickDocImage(docId, isCamera: false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
