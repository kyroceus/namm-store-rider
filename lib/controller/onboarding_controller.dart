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
  final languageController = TextEditingController();

  // Documents
  var documents = <DocumentModel>[].obs;

  // Loading State
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load documents if we are at that stage
    if (_service.getCurrentStep() == OnboardingStep.documents) {
      loadDocuments();
    }
  }

  // --- Actions ---

  Future<void> sendOtp() async {
    if (mobileController.text.length != 10) {
      showCustomSnackBar(
        title: "Error",
        message: "Invalid Mobile Number",
        snackBarType: SnackBarType.error,
      );
      return;
    }
    isLoading.value = true;
    bool success = await _service.sendOtp(mobileController.text);
    isLoading.value = false;

    if (success) {
      Get.toNamed(Routes.onboardingOtp);
    }
  }

  Future<void> verifyOtp() async {
    isLoading.value = true;
    bool success = await _service.verifyOtp(
      mobileController.text,
      otpController.text,
    );
    isLoading.value = false;

    if (success) {
      Get.toNamed(Routes.onboardingPersonalInfo);
    } else {
      showCustomSnackBar(
        title: "Error",
        message: "Invalid OTP",
        snackBarType: SnackBarType.error,
      );
    }
  }

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

    isLoading.value = true;
    final info = PersonalInfoModel(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      fatherName: fatherNameController.text,
      dob: dobController.text,
      city: cityController.text,
      address: addressController.text,
      language: languageController.text,
    );

    await _service.submitPersonalInfo(info);
    isLoading.value = false;

    loadDocuments();
    Get.toNamed(Routes.onboardingDocuments);
  }

  Future<void> loadDocuments() async {
    isLoading.value = true;
    documents.value = await _service.getDocuments();
    isLoading.value = false;
  }

  Future<void> pickImage(String docId, dynamic source) async {
    // Note: source should be ImageSource.camera or gallery.
    // Using dynamic to avoid import in header if not needed, but better to import image_picker.
    // actually we can just pass bool isCamera
  }

  Future<void> pickDocImage(String docId, {bool isCamera = false}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (image != null) {
      await uploadDocument(docId, image.path);
    }
  }

  Future<void> uploadDocument(String docId, String path) async {
    isLoading.value = true;

    // Update local model first to show preview immediately (optimistic UI)
    var doc = documents.firstWhere((e) => e.id == docId);
    doc = DocumentModel(
      id: doc.id,
      title: doc.title,
      frontImage: path, // Temporarily store local path
      status: DocStatus.uploaded,
      requiresBackSide: doc.requiresBackSide,
    );
    int index = documents.indexWhere((e) => e.id == docId);
    documents[index] = doc;
    documents.refresh();

    await _service.uploadDocument(docId, path);
    isLoading.value = false;
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
