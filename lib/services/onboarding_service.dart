import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nammastore_rider/models/onboarding_model.dart';
import 'package:nammastore_rider/services/http_service.dart';

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
      mobileNumber: _storage.read('mobileNum') ?? '',
      personalInfo: PersonalInfoModel(),
      documents: [
        DocumentModel(
          id: '1',
          title: 'Aadhar Card',
          requiresBackSide: true,
          category: DocCategory.personal,
        ),
        DocumentModel(
          id: '2',
          title: 'PAN Card',
          requiresBackSide: false,
          category: DocCategory.personal,
        ),
        DocumentModel(
          id: '3',
          title: 'Driving License',
          requiresBackSide: true,
          category: DocCategory.personal,
        ),
        DocumentModel(
          id: '4',
          title: 'RC Book',
          requiresBackSide: true,
          category: DocCategory.vehicle,
        ),
        DocumentModel(
          id: '5',
          title: 'Vehicle Insurance',
          requiresBackSide: false,
          category: DocCategory.vehicle,
        ),
        DocumentModel(
          id: '6',
          title: 'Bank Passbook Front Page',
          requiresBackSide: false,
          category: DocCategory.bank,
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

  Future<bool> submitPersonalInfo(PersonalInfoModel info) async {
    try {
      await HttpService.instance.request(
        path: '/v1/rider/profile',
        method: 'POST',
        body: info.toJson(),
        auth: true,
      );
      _mockState.personalInfo = info;
      _saveStep(OnboardingStep.documents);
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }
  }

  Future<List<DocumentModel>> getDocuments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockState.documents;
  }

  Future<bool> uploadDocument(
    String docId, {
    String? frontPath,
    String? backPath,
    String? image,
  }) async {
    final doc = _mockState.documents.firstWhere(
      (element) => element.id == docId,
    );

    String endpoint = '';

    // Map document title to endpoint
    switch (doc.title) {
      case 'Aadhar Card':
        endpoint = '/v1/rider/upload/aadhar';
        break;
      case 'Driving License':
        endpoint = '/v1/rider/upload/driving-license';
        break;
      case 'PAN Card':
        endpoint = '/v1/rider/upload/pan';
        break;
      case 'RC Book':
        endpoint = '/v1/rider/upload/vehicle-rc';
        break;
      case 'Vehicle Insurance':
        endpoint = '/v1/rider/upload/vehicle-insurance';
        break;
      case 'Bank Passbook Front Page':
        endpoint = '/v1/rider/upload/passbook';
        break;
      default:
        Get.snackbar("Error", "Unknown document type");
        return false;
    }

    try {
      final Map<String, String> files = {};
      if (frontPath != null && frontPath.isNotEmpty) {
        files['front'] = frontPath;
      }
      if (backPath != null && backPath.isNotEmpty) {
        files['back'] = backPath;
      }
      if (image != null && image.isNotEmpty) {
        files['image'] = image;
      }

      if (files.isEmpty) {
        Get.snackbar("Error", "No images selected to upload");
        return false;
      }

      await HttpService.instance.uploadFiles(
        path: endpoint,
        files: files,
        auth: true,
      );

      doc.status = DocStatus.uploaded;
      // Ideally update model with paths if server returns them, but for now we trust local
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }
  }

  OnboardingStep getCurrentStep() {
    return _mockState.currentStep;
  }

  String get mobileNumber => _mockState.mobileNumber;

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

  Future<void> fetchUserProfile() async {
    try {
      final response = await HttpService.instance.request(
        path: '/v1/rider',
        method: 'GET',
        auth: true,
      );

      if (response != null && response is Map<String, dynamic>) {
        // Sync Verification Status
        // The user mentioned 'emailVerified' acts as account verification status
        final emailVerified = response['emailVerified'] == true;
        isVerified.value = emailVerified;
        _storage.write('is_verified', emailVerified);

        // Sync Document Status
        for (var doc in _mockState.documents) {
          String? frontUrl;
          String? backUrl;

          switch (doc.title) {
            case 'Aadhar Card':
              frontUrl = response['aadharCardFront'];
              backUrl = response['aadharCardBack'];
              break;
            case 'PAN Card':
              frontUrl = response['panCard'];
              break;
            case 'Driving License':
              frontUrl = response['drivingLicenseFront'];
              backUrl = response['drivingLicenseBack'];
              break;
            case 'RC Book':
              frontUrl = response['vehicleRcBookFront'];
              backUrl = response['vehicleRcBookBack'];
              break;
            case 'Vehicle Insurance':
              frontUrl = response['vehicleInsurance'];
              break;
            case 'Bank Passbook Front Page':
              frontUrl = response['bankPassbook'];
              break;
          }

          bool isUploaded = false;
          // Logic: If required fields are present in response, mark as uploaded
          if (doc.requiresBackSide) {
            if (frontUrl != null && backUrl != null) {
              isUploaded = true;
            }
          } else {
            if (frontUrl != null) {
              isUploaded = true;
            }
          }

          if (isUploaded) {
            doc.status = DocStatus.uploaded;
            doc.frontImage = frontUrl;
            doc.backImage = backUrl;
          }
        }
        if (response['firstName'] != null &&
            _mockState.currentStep == OnboardingStep.phone) {
          // If we have personal info but local step is phone, advance to documents
          _mockState.currentStep = OnboardingStep
              .documents; // Don't save to storage yet or do valid save
          _saveStep(OnboardingStep.documents);
        }

        // _mockState.documents.refresh(); // Removed: Not an RxList
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sync profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<String> getDriverStatus() async {
    // Attempt to sync first
    await fetchUserProfile();

    if (isVerified.value) return 'VERIFIED';

    // If all documents are uploaded, we are in pending verification state
    if (areAllDocsUploaded()) {
      if (_mockState.currentStep != OnboardingStep.verificationPending) {
        _saveStep(OnboardingStep.verificationPending);
      }
      return 'PENDING';
    }

    // Check memory state fallback
    if (_mockState.currentStep == OnboardingStep.verificationPending) {
      return 'PENDING';
    }
    if (_mockState.currentStep == OnboardingStep.complete) {
      return 'PENDING';
    }

    return 'INCOMPLETE';
  }
}
