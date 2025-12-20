import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nammastore_rider/routes/app_pages.dart';
import 'package:nammastore_rider/services/onboarding_service.dart';

class OnboardingSuccessScreen extends StatefulWidget {
  const OnboardingSuccessScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingSuccessScreen> createState() =>
      _OnboardingSuccessScreenState();
}

class _OnboardingSuccessScreenState extends State<OnboardingSuccessScreen> {
  final OnboardingService _service = Get.find<OnboardingService>();

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  void _checkStatus() async {
    // Simulate periodic check or just one-time check on verification
    final status = await _service.getDriverStatus();
    if (status == 'VERIFIED') {
      Get.offAllNamed(Routes.driverDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration Complete"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.hourglass_empty, color: Colors.white),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your application is under verification",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Account will be activated soon",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            _buildStatusItem("Personal Information", "Approved", Colors.green),
            _buildStatusItem(
              "Personal Documents",
              "Verification Pending",
              Colors.orange,
            ),
            _buildStatusItem("Vehicle Details", "Approved", Colors.green),
            _buildStatusItem("Bank Account Details", "Approved", Colors.green),

            const Spacer(),
            Center(
              child: TextButton(
                onPressed: () {
                  // Refresh status check
                  _checkStatus();
                },
                child: const Text("Check Status"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String title, String status, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(status, style: TextStyle(color: color, fontSize: 12)),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}
