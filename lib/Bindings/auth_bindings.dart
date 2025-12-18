import 'package:get/get.dart';
import 'package:nammastore_rider/controller/auth_controller.dart';
import 'package:nammastore_rider/services/auth_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(authService: Get.find<AuthService>()),
    );
    Get.lazyPut<AuthService>(() => AuthService());
  }
}
