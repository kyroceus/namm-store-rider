class RiderModel {
  String? id;
  String? firstName;
  String? lastName;
  String? fatherName;
  DateTime? dateOfBirth;
  String? mobileNumber;
  String? whatsappNumber;
  String? bloodGroup;
  String? city;
  String? address;
  String? aadharCardFront;
  String? aadharCardBack;
  String? panCard;
  String? drivingLicenseFront;
  String? drivingLicenseBack;
  String? vehicleRcBookFront;
  String? vehicleRcBookBack;
  String? vehicleInsurance;
  String? bankPassbook;
  String? accountNumber;
  String? ifsc;
  bool? isDeleted;
  DateTime? deletedAt;
  String? email;
  bool? emailVerified;
  bool? verified;
  DateTime? createdAt;
  String? otp;
  String? walletBalance;
  String? cashOnHand;
  String? currency;
  DateTime? otpSentAt;

  RiderModel({
    this.id,
    this.firstName,
    this.lastName,
    this.fatherName,
    this.dateOfBirth,
    this.mobileNumber,
    this.whatsappNumber,
    this.bloodGroup,
    this.city,
    this.address,
    this.aadharCardFront,
    this.aadharCardBack,
    this.panCard,
    this.drivingLicenseFront,
    this.drivingLicenseBack,
    this.vehicleRcBookFront,
    this.vehicleRcBookBack,
    this.vehicleInsurance,
    this.bankPassbook,
    this.accountNumber,
    this.ifsc,
    this.isDeleted,
    this.deletedAt,
    this.email,
    this.emailVerified,
    this.verified,
    this.createdAt,
    this.otp,
    this.walletBalance,
    this.cashOnHand,
    this.currency,
    this.otpSentAt,
  });

  RiderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    fatherName = json['fatherName'];
    dateOfBirth = json['dateOfBirth'] != null
        ? DateTime.tryParse(json['dateOfBirth'])
        : null;
    mobileNumber = json['mobileNumber'];
    whatsappNumber = json['whatsappNumber'];
    bloodGroup = json['bloodGroup'];
    city = json['city'];
    address = json['address'];
    aadharCardFront = json['aadharCardFront'];
    aadharCardBack = json['aadharCardBack'];
    panCard = json['panCard'];
    drivingLicenseFront = json['drivingLicenseFront'];
    drivingLicenseBack = json['drivingLicenseBack'];
    vehicleRcBookFront = json['vehicleRcBookFront'];
    vehicleRcBookBack = json['vehicleRcBookBack'];
    vehicleInsurance = json['vehicleInsurance'];
    bankPassbook = json['bankPassbook'];
    accountNumber = json['accountNumber'];
    ifsc = json['ifsc'];
    isDeleted = json['isDeleted'];
    deletedAt = json['deletedAt'] != null
        ? DateTime.tryParse(json['deletedAt'])
        : null;
    email = json['email'];
    emailVerified = json['emailVerified'];
    verified = json['verified'];
    createdAt = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'])
        : null;
    otp = json['otp'];
    walletBalance = json['walletBalance'];
    cashOnHand = json['cashOnHand'];
    currency = json['currency'];
    otpSentAt = json['otpSentAt'] != null
        ? DateTime.tryParse(json['otpSentAt'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['fatherName'] = fatherName;
    data['dateOfBirth'] = dateOfBirth?.toIso8601String();
    data['mobileNumber'] = mobileNumber;
    data['whatsappNumber'] = whatsappNumber;
    data['bloodGroup'] = bloodGroup;
    data['city'] = city;
    data['address'] = address;
    data['aadharCardFront'] = aadharCardFront;
    data['aadharCardBack'] = aadharCardBack;
    data['panCard'] = panCard;
    data['drivingLicenseFront'] = drivingLicenseFront;
    data['drivingLicenseBack'] = drivingLicenseBack;
    data['vehicleRcBookFront'] = vehicleRcBookFront;
    data['vehicleRcBookBack'] = vehicleRcBookBack;
    data['vehicleInsurance'] = vehicleInsurance;
    data['bankPassbook'] = bankPassbook;
    data['accountNumber'] = accountNumber;
    data['ifsc'] = ifsc;
    data['isDeleted'] = isDeleted;
    data['deletedAt'] = deletedAt?.toIso8601String();
    data['email'] = email;
    data['emailVerified'] = emailVerified;
    data['verified'] = verified;
    data['createdAt'] = createdAt?.toIso8601String();
    data['otp'] = otp;
    data['walletBalance'] = walletBalance;
    data['cashOnHand'] = cashOnHand;
    data['currency'] = currency;
    data['otpSentAt'] = otpSentAt?.toIso8601String();
    return data;
  }
}
