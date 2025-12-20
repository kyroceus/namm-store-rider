import 'package:get/get.dart';
import 'package:nammastore_rider/controller/onboarding_controller.dart';
import 'package:nammastore_rider/services/onboarding_service.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    // Keep service alive
    Get.lazyPut<OnboardingService>(() => OnboardingService(), fenix: true);
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
      fenix: true,
    );
  }
}
