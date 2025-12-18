import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nammastore_rider/controller/auth_controller.dart';
import 'package:nammastore_rider/services/http_service.dart';
import 'package:nammastore_rider/utils/loading_dialogue.dart';
import 'package:nammastore_rider/widgets/custom_snackbar.dart';

import '../routes/app_pages.dart';

final GetStorage storage = GetStorage();

class AuthService extends GetxService {
  String authToken;
  String mobileNum;

  AuthService()
    : authToken = storage.read('token') ?? '',
      mobileNum = storage.read('mobileNum') ?? '';

  bool get isLoggedIn => authToken.isNotEmpty;

  Future<bool> loginWithMobile(String mobileNum) async {
    if (mobileNum.isEmpty || mobileNum.length != 10) {
      showCustomSnackBar(
        title: "Error",
        message: "Enter a valid 10-digit mobile number",
        snackBarType: SnackBarType.error,
      );
      return false;
    }

    try {
      showLoadingDialog();

      await HttpService.instance.request(
        path: '/v1/user/login',
        body: {"mobileNumber": mobileNum},
        method: 'POST',
      );

      Get.back(); // Close loader
      showCustomSnackBar(
        title: "Success",
        message: "OTP Sent Successfully!",
        snackBarType: SnackBarType.success,
      );
      return true;
    } catch (e) {
      Get.back(); // Close loader
      showCustomSnackBar(
        title: "Error",
        message: e.toString(),
        snackBarType: SnackBarType.error,
      );
      return false;
    }
  }

  Future<String> verifyOtp(String mobileNum, String otp) async {
    if (otp.isEmpty || otp.length != 6) {
      showCustomSnackBar(
        title: "Error",
        message: "Enter a valid 6-digit OTP",
        snackBarType: SnackBarType.error,
      );
      return '';
    }

    try {
      showLoadingDialog(); // ⏳ Show loading

      final data = await HttpService.instance.request(
        path: '/v1/user/verify',
        body: {"mobileNumber": mobileNum, "otp": otp},
        method: 'POST',
      );

      Get.back();
      showCustomSnackBar(
        title: "Success",
        message: "Login Successful!",
        snackBarType: SnackBarType.success,
      );
      await Future.delayed(Duration(milliseconds: 200));
      Get.offAllNamed(Routes.homeScreen);
      authToken = data;
      return authToken;
    } catch (e) {
      showCustomSnackBar(
        title: "Error",
        message: e.toString(),
        snackBarType: SnackBarType.error,
      );
      if (Get.isDialogOpen ?? false) Get.back(); // ✅ Safe cleanup
    }

    return '';
  }

  Future<void> sendOtpForDeletion() async {
    try {
      await HttpService.instance.request(
        path: '/v1/user/initiate-delete',
        auth: true,
        method: 'POST',
      );
      showCustomSnackBar(
        title: "OTP Sent",
        message: "OTP has been sent to your mobile",
        snackBarType: SnackBarType.success,
      );
    } catch (e) {
      showCustomSnackBar(
        title: "Error",
        message: e.toString(),
        snackBarType: SnackBarType.error,
      );
    }
  }

  Future<void> verifyOtpAndRequestDelete(String otp) async {
    try {
      await HttpService.instance.request(
        path: '/v1//user/delete',
        body: {'otp': otp},
        auth: true,
        method: 'POST',
      );
      Get.find<AuthController>().logout();
      showCustomSnackBar(
        title: "Account Deleted",
        message: "Your account has been successfully deleted",
        snackBarType: SnackBarType.success,
      );
    } catch (e) {
      showCustomSnackBar(
        title: "Error",
        message: e.toString(),
        snackBarType: SnackBarType.error,
      );
    }
  }
}
