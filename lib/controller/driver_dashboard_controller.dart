import 'package:get/get.dart';
import 'package:nammastore_rider/controller/socket_controller.dart';

class DriverDashboardController extends GetxController {
  final SocketController socketController = Get.find<SocketController>();

  var isOnline = false.obs;
  var selectedDate = DateTime.now().obs;
  var currentBottomNavIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Simulate a JWT token login
    final fakeJwt = "eyJhbGciOiJIUzI1NiJ9.USER_PAYLOAD_HERE.SIGNATURE";

    // Initialize Socket (setups listeners)
    socketController.init(fakeJwt);

    // Initial state check
    if (isOnline.value) {
      socketController.connect();
    } else {
      socketController.disconnect();
    }
  }

  void toggleStatus(bool online) {
    isOnline.value = online;
    if (online) {
      socketController.connect();
    } else {
      socketController.disconnect();
    }
  }

  void updateDate(DateTime date) {
    selectedDate.value = date;
    // Todo: Fetch orders for date
  }

  void changeBottomNavIndex(int index) {
    currentBottomNavIndex.value = index;
  }

  void pickOrder(String orderId) {
    socketController.pickOrder(orderId);
  }
}
