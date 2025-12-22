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
  final secondaryMobileController = TextEditingController();
  final bloodGroupController = TextEditingController();
  var profileImagePath = ''.obs;

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
      secondaryMobile: secondaryMobileController.text,
      bloodGroup: bloodGroupController.text,
      profileImage: profileImagePath.value,
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

  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImagePath.value = image.path;
    }
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
      await uploadDocument(docId, image.path, isBack: isBack);
    }
  }

  Future<void> uploadDocument(
    String docId,
    String path, {
    bool isBack = false,
  }) async {
    isLoading.value = true;

    // Update local model first to show preview immediately (optimistic UI)
    var doc = documents.firstWhere((e) => e.id == docId);

    // Create new document with updated image path
    doc = DocumentModel(
      id: doc.id,
      title: doc.title,
      frontImage: isBack ? doc.frontImage : path,
      backImage: isBack ? path : doc.backImage,
      // Status logic: if we have both sides (or only need one), mark uploaded?
      // For now, let service handle status or keep as uploaded if touched.
      // We can refine: if (requiresBackSide && (front == null || back == null)) -> pending?
      // Simple approach: set uploaded if we have this new image.
      // Ideally validation happens on submit.
      status: DocStatus.uploaded,
      requiresBackSide: doc.requiresBackSide,
      category: doc.category,
    );

    int index = documents.indexWhere((e) => e.id == docId);
    documents[index] = doc;
    documents.refresh();

    await _service.uploadDocument(docId, path, isBack: isBack);
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
