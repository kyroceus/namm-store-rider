class AuthModel {
  final String mobileNum;
  final String token;

  AuthModel({required this.mobileNum, required this.token});
  factory AuthModel.fromJson(Map<String, Object?> json) {
    return AuthModel(
      mobileNum: json['mobileNumber'] as String,
      token: json['token'] as String,
    );
  }
  Map<String, Object?> toJson() {
    return {'mobileNumber': mobileNum, 'token': token};
  }
}
