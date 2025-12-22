enum OnboardingStep {
  phone,
  otp,
  personalInfo,
  documents,
  verificationPending,
  complete,
}

enum DocStatus { pending, uploaded, approved, rejected }

enum DocCategory { personal, vehicle, bank, emergency }

class DocumentModel {
  final String id;
  final String title;
  final String? frontImage;
  final String? backImage;
  DocStatus status;
  final bool requiresBackSide;
  final DocCategory category;

  DocumentModel({
    required this.id,
    required this.title,
    required this.category,
    this.frontImage,
    this.backImage,
    this.status = DocStatus.pending,
    this.requiresBackSide = false,
  });
}

class PersonalInfoModel {
  String firstName;
  String lastName;
  String fatherName;
  String dob;
  String city;
  String address;
  String language;
  String profileImage;
  String whatsApp;
  String secondaryMobile;
  String bloodGroup;
  String referralCode;

  PersonalInfoModel({
    this.firstName = '',
    this.lastName = '',
    this.fatherName = '',
    this.dob = '',
    this.city = '',
    this.address = '',
    this.language = '',
    this.profileImage = '',
    this.whatsApp = '',
    this.secondaryMobile = '',
    this.bloodGroup = '',
    this.referralCode = '',
  });
}

class OnboardingState {
  OnboardingStep currentStep;
  PersonalInfoModel personalInfo;
  List<DocumentModel> documents;
  String mobileNumber;

  OnboardingState({
    this.currentStep = OnboardingStep.phone,
    required this.personalInfo,
    required this.documents,
    this.mobileNumber = '',
  });
}
