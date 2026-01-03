import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nammastore_rider/models/onboarding_model.dart';
import 'package:nammastore_rider/routes/app_pages.dart';
import 'package:nammastore_rider/services/onboarding_service.dart';
import 'package:nammastore_rider/widgets/custom_snackbar.dart';

class OnboardingController extends GetxController {
  final OnboardingService _service = Get.find<OnboardingService>();

  // Phone Step
  final mobileController = TextEditingController();

  // OTP Step
  final otpController = TextEditingController();

  // Personal Info Step
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final dobController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();

  final whatsAppController = TextEditingController();
  final bloodGroupController = TextEditingController();

  var isWhatsAppSameAsMobile = false.obs;

  void toggleWhatsAppSameAsMobile(bool? value) {
    isWhatsAppSameAsMobile.value = value ?? false;
    if (isWhatsAppSameAsMobile.value) {
      whatsAppController.text = mobileController.text;
    } else {
      whatsAppController.clear();
    }
  }

  // Documents
  var documents = <DocumentModel>[].obs;

  // Loading State
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Auto-fill mobile number
    mobileController.text = _service.mobileNumber;

    // Load documents if we are at that stage
    if (_service.getCurrentStep() == OnboardingStep.documents) {
      loadDocuments();
    }
  }

  // --- Actions ---

  Future<void> submitPersonalInfo() async {
    // Basic validation
    if (firstNameController.text.isEmpty) {
      showCustomSnackBar(
        title: "Error",
        message: "Enter First Name",
        snackBarType: SnackBarType.error,
      );
      return;
    }

    // DOB Validation (18+ years)
    if (dobController.text.isEmpty) {
      showCustomSnackBar(
        title: "Error",
        message: "Enter Date of Birth",
        snackBarType: SnackBarType.error,
      );
      return;
    }

    try {
      // Parse format "d/M/yyyy" as set in screen
      final parts = dobController.text.split('/');
      final dob = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
      final now = DateTime.now();
      final age =
          now.year -
          dob.year -
          ((now.month < dob.month ||
                  (now.month == dob.month && now.day < dob.day))
              ? 1
              : 0);

      if (age < 18) {
        showCustomSnackBar(
          title: "Sorry",
          message: "Go and study",
          snackBarType: SnackBarType.error,
        );
        return;
      }
    } catch (e) {
      showCustomSnackBar(
        title: "Error",
        message: "Invalid Date Format",
        snackBarType: SnackBarType.error,
      );
      return;
    }

    isLoading.value = true;
    final info = PersonalInfoModel(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      fatherName: fatherNameController.text,
      dob: dobController.text,
      city: cityController.text,
      address: addressController.text,
      whatsApp: whatsAppController.text,
      bloodGroup: bloodGroupController.text,
    );

    await _service.submitPersonalInfo(info);
    isLoading.value = false;

    loadDocuments();
    Get.toNamed(Routes.onboardingDocuments);
  }

  Future<void> loadDocuments() async {
    isLoading.value = true;
    await _service.fetchUserProfile(); // Sync from server
    documents.value = await _service.getDocuments();
    isLoading.value = false;
  }

  Future<void> pickImage(String docId, dynamic source) async {
    // Note: source should be ImageSource.camera or gallery.
    // Using dynamic to avoid import in header if not needed, but better to import image_picker.
    // actually we can just pass bool isCamera
  }

  Future<void> pickDocImage(
    String docId, {
    bool isCamera = false,
    bool isBack = false,
  }) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (image != null) {
      // Update local state ONLY
      var doc = documents.firstWhere((e) => e.id == docId);

      doc = DocumentModel(
        id: doc.id,
        title: doc.title,
        frontImage: isBack ? doc.frontImage : image.path,
        backImage: isBack ? image.path : doc.backImage,
        status: doc.status, // Keep existing status until actual submit
        requiresBackSide: doc.requiresBackSide,
        category: doc.category,
      );

      int index = documents.indexWhere((e) => e.id == docId);
      documents[index] = doc;
      documents.refresh();
    }
  }

  Future<void> submitDocument(String docId) async {
    isLoading.value = true;
    final doc = documents.firstWhere((e) => e.id == docId);

    // Basic Validation
    if (doc.frontImage == null ||
        (doc.requiresBackSide && doc.backImage == null)) {
      showCustomSnackBar(
        title: "Error",
        message: "Please select images first",
        snackBarType: SnackBarType.error,
      );
      isLoading.value = false;
      return;
    }

    final success = await _service.uploadDocument(
      docId,
      frontPath: doc.frontImage,
      backPath: doc.backImage,
    );

    if (success) {
      // Update status on success
      var updatedDoc = DocumentModel(
        id: doc.id,
        title: doc.title,
        frontImage: doc.frontImage,
        backImage: doc.backImage,
        status: DocStatus.uploaded,
        requiresBackSide: doc.requiresBackSide,
        category: doc.category,
      );
      int index = documents.indexWhere((e) => e.id == docId);
      documents[index] = updatedDoc;
      documents.refresh();

      Get.back(); // Go back to list
      showCustomSnackBar(
        title: "Success",
        message: "${doc.title} uploaded successfully",
        snackBarType: SnackBarType.success,
      );
    }
    isLoading.value = false;
  }

  bool isCategoryCompleted(DocCategory category) {
    final categoryDocs = documents.where((doc) => doc.category == category);
    if (categoryDocs.isEmpty) return false;
    return categoryDocs.every(
      (doc) =>
          doc.status == DocStatus.uploaded || doc.status == DocStatus.approved,
    );
  }

  Future<void> submitAllDocuments() async {
    if (!_service.areAllDocsUploaded()) {
      showCustomSnackBar(
        title: "Error",
        message: "Please upload all documents",
        snackBarType: SnackBarType.error,
      );
      return;
    }

    isLoading.value = true;
    await _service.submitForVerification();
    isLoading.value = false;

    Get.offAllNamed(Routes.onboardingSuccess);
  }
}
