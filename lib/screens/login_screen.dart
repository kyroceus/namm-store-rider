import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nammastore_rider/consts/app_colors.dart';
import 'package:nammastore_rider/controller/auth_controller.dart';
import 'package:nammastore_rider/controller/otp_controller.dart';
import 'package:nammastore_rider/routes/app_pages.dart';
import 'package:nammastore_rider/widgets/custom_snackbar.dart';
import 'package:pinput/pinput.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final OtpController otpController = Get.find<OtpController>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!authController.hasShownSheet) {
        authController.hasShownSheet = true;
        _showMobileNumberBottomSheet(context, otpController, authController);
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [AppColors.primary, AppColors.background1],
          ),
        ),
        child: Stack(
          children: [
            // ✅ 1. Background Kolam
            Positioned.fill(
              child: Opacity(
                opacity: 0.06,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                  ),
                  itemCount: 500,
                  itemBuilder: (context, index) => Image.asset(
                    'assets/icons/Decoration_Kolam.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),

            // ✅ 2. Top-left Logo and Title
            Positioned(
              top: 80,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/icons/Loader.png', width: 80, height: 80),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Namma Store",
                      style: GoogleFonts.coiny(
                        fontSize: 26,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "இது நம்ம கடை",
                      style: GoogleFonts.coiny(
                        fontSize: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMobileNumberBottomSheet(
    BuildContext context,
    OtpController otpController,
    AuthController authController,
  ) {
    final TextEditingController mobileController = TextEditingController();
    showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      barrierColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background2,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              top: 24,
              left: 24,
              right: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📱 Login Title
                Text(
                  "Login or Signup",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 20),

                // 📞 Phone Number Input
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.background2,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      const Text("+91", style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: mobileController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            hintText: "Enter your phone number",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 🔘 Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final otpSent = await authController
                          .loginWithMobileNumber(mobileController.text.trim());
                      if (otpSent) {
                        _showOtpBottomSheet(
                          // ignore: use_build_context_synchronously
                          context,
                          otpController,
                          authController,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      authController.skipLogin();
                      Get.offAllNamed(
                        Routes.homeScreen,
                      ); // 🔁 Go to home directly
                    },

                    child: Text(
                      "Skip Login",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 📜 Terms and Policy
                Text.rich(
                  TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: const TextStyle(fontSize: 14),
                    children: [
                      _linkText('Terms of Service'),
                      const TextSpan(text: ', '),
                      _linkText('Privacy Policy'),
                      const TextSpan(text: ' and '),
                      _linkText('Caution Notice'),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  TextSpan _linkText(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        decoration: TextDecoration.underline,
        color: AppColors.textTertiary,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          // if (text == 'Terms of Service') {
          //   Get.toNamed(Routes.tsScreen); // replace with your actual route
          // } else if (text == 'Privacy Policy') {
          //   Get.toNamed(Routes.privacyPolicyScreen);
          // } else if (text == 'Caution Notice') {
          //   Get.toNamed(Routes.cautionNoticeScreen);
          // }
        },
    );
  }
}

void _showOtpBottomSheet(
  BuildContext context,
  OtpController controller,
  AuthController authController,
) {
  showModalBottomSheet(
    barrierColor: Colors.transparent,
    enableDrag: false,
    isDismissible: false,
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background2,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 18,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Verify with OTP",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.textTertiary),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "6 digit OTP has been sent to your number",
                style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    "+91 ${authController.mobileNum}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Not Yours?",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      "Change",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.tertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Pinput(
                scrollPadding: const EdgeInsets.all(95),
                key: ValueKey(controller.refreshOtpField.value),
                length: controller.otpLength,
                autofocus: true,
                defaultPinTheme: PinTheme(
                  width: 54,
                  height: 75,
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background2,
                    border: Border.all(color: AppColors.primary.withAlpha(127)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 54,
                  height: 75,
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background2,
                    border: Border.all(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) => controller.otp.value = value,
                onSubmitted: (value) {
                  controller.otp.value = value;
                  authController.verifyOTP(value);
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Didn't receive a OTP?",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  SizedBox(width: 4),
                  Obx(() {
                    return controller.isTimerFinished.value
                        ? GestureDetector(
                            onTap: () => controller.resendOtp(),
                            child: Text(
                              "Resend OTP",
                              style: TextStyle(
                                color: AppColors.tertiary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Text(
                            "Resend OTP in ${controller.secondsRemaining.value}s",
                            style: TextStyle(color: Colors.grey),
                          );
                  }),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.otp.value.length == controller.otpLength) {
                      authController.verifyOTP(controller.otp.value);
                    } else {
                      showCustomSnackBar(
                        title: "Invalid OTP",
                        message: "Please enter the complete OTP",
                        snackBarType: SnackBarType.error,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textAlt,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Verify OTP",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
