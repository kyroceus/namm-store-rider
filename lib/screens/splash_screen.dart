import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nammastore_rider/controller/auth_controller.dart';
import 'package:nammastore_rider/routes/app_pages.dart';
import 'package:nammastore_rider/services/onboarding_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

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
    final OnboardingService onboarding = Get.find<OnboardingService>();

    if (auth.isLoggedIn.value) {
      // Check onboarding status
      final status = await onboarding.getDriverStatus();
      if (status == 'VERIFIED') {
        Get.offAllNamed(Routes.driverDashboard);
      } else if (status == 'PENDING') {
        Get.offAllNamed(Routes.driverDashboard);
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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo here
            Image.asset('assets/icons/Loader.png', width: 100, height: 100),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.red),
          ],
        ),
      ),
    );
  }
}
