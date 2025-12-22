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
                orElse: () => DocumentModel(
                  id: '0',
                  title: '',
                  category: DocCategory.personal,
                ),
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
          orElse: () => DocumentModel(
            id: '0',
            title: 'Unknown',
            category: DocCategory.personal,
          ),
        );

        return SingleChildScrollView(
          // Changed to ScrollView for scalability
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- FRONT SIDE ---
              Text("Front side photo of your ${doc.title}"),
              const SizedBox(height: 10),
              _buildUploadBox(
                context,
                imagePath: doc.frontImage,
                onTap: () => _showPicker(context, docId, isBack: false),
                label: "Upload Front Side",
              ),
              const SizedBox(height: 20),

              // --- BACK SIDE (Optional) ---
              if (doc.requiresBackSide) ...[
                Text("Back side photo of your ${doc.title}"),
                const SizedBox(height: 10),
                _buildUploadBox(
                  context,
                  imagePath: doc.backImage,
                  onTap: () => _showPicker(context, docId, isBack: true),
                  label: "Upload Back Side",
                ),
                const SizedBox(height: 30),
              ],

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      (doc.frontImage == null ||
                          (doc.requiresBackSide && doc.backImage == null))
                      ? null // Disable if required images are missing
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

  Widget _buildUploadBox(
    BuildContext context, {
    required String? imagePath,
    required VoidCallback onTap,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
              image: imagePath != null && imagePath.isNotEmpty
                  ? DecorationImage(
                      image: imagePath.startsWith('http')
                          ? NetworkImage(imagePath)
                          : FileImage(File(imagePath)) as ImageProvider,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imagePath != null
                ? null // Image is shown in decoration
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cloud_upload_outlined,
                          size: 40,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 10),
                        Text(label, style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
          ),
          if (imagePath != null)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                "Tap to change",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  void _showPicker(BuildContext context, String docId, {required bool isBack}) {
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
                controller.pickDocImage(docId, isCamera: true, isBack: isBack);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                controller.pickDocImage(docId, isCamera: false, isBack: isBack);
              },
            ),
          ],
        ),
      ),
    );
  }
}
