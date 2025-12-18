import 'dart:async';
import 'package:get/get.dart';
import 'package:nammastore_rider/controller/auth_controller.dart';

class OtpController extends GetxController {
  final otpLength = 6;
  final AuthController authController = Get.find<AuthController>();

  var otp = ''.obs;
  var refreshOtpField = false.obs;

  // Timer logic
  var isTimerFinished = false.obs;
  var secondsRemaining = 30.obs;
  Timer? _timer;
  bool hasShownSheet = false;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void clearOtp() {
    otp.value = '';
    refreshOtpField.toggle();
  }

  void startTimer() {
    isTimerFinished.value = false;
    secondsRemaining.value = 30;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        isTimerFinished.value = true;
        timer.cancel();
      }
    });
  }

  void resendOtp() {
    clearOtp(); // 🧼 Reset OTP
    authController.loginWithMobileNumber(authController.mobileNum.value);
    startTimer(); // ⏱ Restart countdown
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
