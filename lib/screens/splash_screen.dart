import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nammastore_rider/consts/app_colors.dart';
import 'package:nammastore_rider/controller/auth_controller.dart';
import 'package:nammastore_rider/routes/app_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkState();
  }

  void _checkState() async {
    // Wait a moment for services/animations
    await Future.delayed(const Duration(seconds: 2));

    final AuthController auth = Get.find<AuthController>();

    if (auth.isLoggedIn.value) {
      // Check onboarding status
      await auth.fetchUserProfile();
      final rider = auth.user.value;

      if (rider != null) {
        if (rider.firstName == null) {
          Get.offAllNamed(Routes.onboardingPersonalInfo);
        } else if (rider.verified == false) {
          Get.offAllNamed(Routes.onboardingSuccess);
        } else {
          Get.offAllNamed(Routes.driverDashboard);
        }
      } else {
        Get.offAllNamed(Routes.onboardingPersonalInfo);
      }
    } else {
      Get.offAllNamed(Routes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashScreenColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo here
            // Your logo here
            Image.asset('assets/icons/loader.gif', width: 150, height: 150),
          ],
        ),
      ),
    );
  }
}
