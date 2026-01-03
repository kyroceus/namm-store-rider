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
  String? frontImage;
  String? backImage;
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
  String whatsApp;
  String bloodGroup;

  PersonalInfoModel({
    this.firstName = '',
    this.lastName = '',
    this.fatherName = '',
    this.dob = '',
    this.city = '',
    this.address = '',
    this.whatsApp = '',
    this.bloodGroup = '',
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "fatherName": fatherName,
      "dateOfBirth": dob, // Mapping dob to dateOfBirth as per JSON body
      "whatsappNumber": whatsApp, // Mapping whatsApp to whatsappNumber
      "bloodGroup": bloodGroup,
      "city": city,
      "address": address,
    };
  }
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
