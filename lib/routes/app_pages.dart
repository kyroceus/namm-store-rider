import 'package:get/get.dart';
import 'package:nammastore_rider/Bindings/auth_bindings.dart';
import 'package:nammastore_rider/screens/home_screen.dart';
import 'package:nammastore_rider/screens/login_screen.dart';
import 'package:nammastore_rider/screens/driver_dashboard.dart';
import 'package:nammastore_rider/Bindings/driver_dashboard_binding.dart';
import 'package:nammastore_rider/Bindings/onboarding_binding.dart';
import 'package:nammastore_rider/screens/onboarding/onboarding_document_list_screen.dart';
import 'package:nammastore_rider/screens/onboarding/onboarding_category_docs_screen.dart';
import 'package:nammastore_rider/screens/onboarding/onboarding_personal_info_screen.dart';
import 'package:nammastore_rider/screens/onboarding/onboarding_success_screen.dart';
import 'package:nammastore_rider/screens/onboarding/onboarding_upload_doc_screen.dart';
import 'package:nammastore_rider/screens/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.loginScreen,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),

    GetPage(name: Routes.homeScreen, page: () => HomeScreen()),
    GetPage(
      name: Routes.driverDashboard,
      page: () => const DriverDashboard(),
      binding: DriverDashboardBinding(),
    ),

    // Onboarding Routes
    GetPage(
      name: Routes.onboardingPersonalInfo,
      page: () => const OnboardingPersonalInfoScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.onboardingDocuments,
      page: () => const OnboardingDocumentListScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.onboardingCategoryDocs,
      page: () => const OnboardingCategoryDocsScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.onboardingUploadDoc,
      page: () => const OnboardingUploadDocScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.onboardingSuccess,
      page: () => const OnboardingSuccessScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(name: Routes.splashScreen, page: () => const SplashScreen()),
  ];
}
