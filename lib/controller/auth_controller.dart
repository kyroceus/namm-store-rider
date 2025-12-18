import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nammastore_rider/services/auth_service.dart';
import 'package:nammastore_rider/services/logger_service.dart';
import 'package:nammastore_rider/widgets/custom_snackbar.dart';
import 'dart:async';

class AuthController extends GetxController {
  var isLoading = true.obs;
  var userId = ''.obs;
  var mobileNum = ''.obs;
  var token = ''.obs;
  var isLoggedIn = false.obs; // ✅ Login state tracker
  bool get isGuest => !isLoggedIn.value;
  bool hasShownSheet = false;

  final AuthService authService;
  final GetStorage storage = GetStorage();

  // OTP Related
  final otp = ''.obs;
  final int otpLength = 6;
  final isTimerFinished = false.obs;
  final secondsRemaining = 30.obs;
  Timer? _timer;

  AuthController({required this.authService}) {
    token.value = storage.read('token') ?? '';
    mobileNum.value = storage.read('mobileNum') ?? '';
    isLoggedIn.value = token.isNotEmpty; // ✅ Auto-detect login on init
  }

  Future<bool> loginWithMobileNumber(String mobileNum) async {
    try {
      isLoading(true);

      // 🚫 Check per-device limit instead of per-number
      if (isRateLimitedForDevice()) {
        showCustomSnackBar(
          title: "Too Many Requests",
          message:
              "You’ve reached the OTP limit on this device. Try again after 1 hour.",
          snackBarType: SnackBarType.info,
        );
        isLoading(false);
        return false;
      }

      this.mobileNum(mobileNum);
      storage.write('mobileNum', mobileNum);

      final otpSent = await authService.loginWithMobile(mobileNum);
      if (!otpSent) {
        isLoading(false);
        return false;
      }

      recordOtpRequestForDevice(); // ✅ Track this device’s OTP attempt
      startOtpTimer();
      isLoading(false);
      return true;
    } catch (e) {
      isLoading(false);
      return false;
    }
  }

  void recordOtpRequestForDevice() {
    final key = 'device_otp_timestamps';
    final List<dynamic> rawList = storage.read<List<dynamic>>(key) ?? [];
    final List<int> timestamps = rawList.cast<int>();

    final now = DateTime.now().millisecondsSinceEpoch;
    timestamps.add(now);

    storage.write(key, timestamps);
  }

  bool isRateLimitedForDevice() {
    final key = 'device_otp_timestamps';
    final List<dynamic> rawList = storage.read<List<dynamic>>(key) ?? [];
    final List<int> timestamps = rawList.cast<int>();

    final now = DateTime.now().millisecondsSinceEpoch;
    const oneHour = 60 * 60 * 1000;

    // Keep only recent timestamps
    final recent = timestamps.where((t) => now - t < oneHour).toList();

    // Update stored list with only recent requests
    storage.write(key, recent);

    // Allow max 3 requests in 1 hour
    return recent.length >= 5;
  }

  Future<void> sendOtpForDeletion() async {
    try {
      isLoading(true);
      await authService.sendOtpForDeletion();
      startOtpTimer();
    } catch (e) {
      AppLogger.instance.e('Unable to send otp for deletion', error: e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> verifyOtpAndRequestDelete(String otp) async {
    try {
      isLoading(true);
      await authService.verifyOtpAndRequestDelete(otp);

      // 🕒 Wait for dialog to appear
      await Future.delayed(Duration(milliseconds: 300));
      await Future.delayed(Duration(seconds: 2));

      // ✅ Dismiss the dialog and navigate
      if (Get.isDialogOpen ?? false) Get.back(); // Close dialog
    } catch (e) {
      // Handle error if needed
      showCustomSnackBar(
        title: "Error",
        message: "Something went wrong",
        snackBarType: SnackBarType.error,
      );
    } finally {
      isLoading(false);
    }
  }

  void verifyOTP(String otp) async {
    try {
      isLoading(true);
      final String token = await authService.verifyOtp(mobileNum.value, otp);
      this.token(token);
      storage.write('token', token);
      isLoggedIn.value = true; // ✅ Set login state after OTP verification
    } catch (e) {
      AppLogger.instance.e('Unable to verify OTP', error: e);
    } finally {
      isLoading(false);
    }
  }

  void skipLogin() {
    token.value = '';
    mobileNum.value = '';
    isLoggedIn.value = false;
    storage.remove('token');
    storage.remove('mobileNum');
  }

  void logout() async {
    token('');
    mobileNum('');
    storage.remove('token');
    storage.remove('mobileNum');
    isLoggedIn.value = false; // ✅ Reset login state
  }

  void startOtpTimer() {
    secondsRemaining.value = 30;
    isTimerFinished.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining.value--;
      } else {
        isTimerFinished.value = true;
        _timer?.cancel();
      }
    });
  }

  void resendOtp() {
    loginWithMobileNumber(mobileNum.value);
    startOtpTimer();
  }

  void updateOtp(String value) {
    otp.value = value;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
