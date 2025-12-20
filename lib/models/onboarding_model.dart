enum OnboardingStep {
  phone,
  otp,
  personalInfo,
  documents,
  verificationPending,
  complete,
}

enum DocStatus { pending, uploaded, approved, rejected }

class DocumentModel {
  final String id;
  final String title;
  final String? frontImage;
  final String? backImage;
  DocStatus status;
  final bool requiresBackSide;

  DocumentModel({
    required this.id,
    required this.title,
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

  PersonalInfoModel({
    this.firstName = '',
    this.lastName = '',
    this.fatherName = '',
    this.dob = '',
    this.city = '',
    this.address = '',
    this.language = '',
    this.profileImage = '',
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
