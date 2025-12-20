import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nammastore_rider/models/onboarding_model.dart';

class OnboardingService extends GetxService {
  final _storage = GetStorage();

  // In-memory state, sync with storage
  late OnboardingState _mockState;

  var isVerified = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadState();
  }

  void _loadState() {
    // Restore step from storage or default
    String? stepStr = _storage.read('onboarding_step');
    OnboardingStep step = OnboardingStep.phone;
    if (stepStr != null) {
      step = OnboardingStep.values.firstWhere(
        (e) => e.toString() == stepStr,
        orElse: () => OnboardingStep.phone,
      );
    }

    // For demo, we recreate Documents/PersonalInfo objects (simplified persistence)
    // In real app, you'd deserialize full JSON
    _mockState = OnboardingState(
      currentStep: step,
      personalInfo: PersonalInfoModel(),
      documents: [
        DocumentModel(id: '1', title: 'Aadhar Card', requiresBackSide: true),
        DocumentModel(id: '2', title: 'PAN Card', requiresBackSide: false),
        DocumentModel(
          id: '3',
          title: 'Driving License',
          requiresBackSide: true,
        ),
      ],
    );
    // In a real app, we would restore document status here too.
    // For this mocked version, we might want to check storage for "docs_uploaded" flag?
    // For now, if step is beyond documents, we mark them uploaded for consistency
    if (step.index > OnboardingStep.documents.index) {
      for (var doc in _mockState.documents) {
        doc.status = DocStatus.uploaded;
      }
    }
  }

  void _saveStep(OnboardingStep step) {
    _mockState.currentStep = step;
    _storage.write('onboarding_step', step.toString());
  }

  Future<bool> sendOtp(String mobile) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockState.mobileNumber = mobile;
    return true;
  }

  Future<bool> verifyOtp(String mobile, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    if (otp == "123456") {
      _saveStep(OnboardingStep.personalInfo);
      return true;
    }
    return false;
  }

  Future<bool> submitPersonalInfo(PersonalInfoModel info) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockState.personalInfo = info;
    _saveStep(OnboardingStep.documents);
    return true;
  }

  Future<List<DocumentModel>> getDocuments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockState.documents;
  }

  Future<bool> uploadDocument(
    String docId,
    String path, {
    bool isBack = false,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final doc = _mockState.documents.firstWhere(
      (element) => element.id == docId,
    );
    doc.status = DocStatus.uploaded;
    return true;
  }

  OnboardingStep getCurrentStep() {
    return _mockState.currentStep;
  }

  bool areAllDocsUploaded() {
    return _mockState.documents.every(
      (doc) =>
          doc.status == DocStatus.uploaded || doc.status == DocStatus.approved,
    );
  }

  Future<void> submitForVerification() async {
    await Future.delayed(const Duration(seconds: 1));
    _saveStep(OnboardingStep.verificationPending);
  }

  Future<String> getDriverStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (isVerified.value) return 'VERIFIED';

    // Check memory state
    if (_mockState.currentStep == OnboardingStep.verificationPending)
      return 'PENDING';
    if (_mockState.currentStep == OnboardingStep.complete ||
        _mockState.currentStep == OnboardingStep.verificationPending)
      return 'PENDING';

    // Explicit check for demo: if stored step is pending
    if (_storage.read('onboarding_step') ==
        OnboardingStep.verificationPending.toString()) {
      return 'PENDING';
    }

    return 'INCOMPLETE';
  }
}
