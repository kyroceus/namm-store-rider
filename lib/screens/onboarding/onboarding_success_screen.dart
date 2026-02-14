import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nammastore_rider/controller/auth_controller.dart';
import 'package:nammastore_rider/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingSuccessScreen extends StatefulWidget {
  const OnboardingSuccessScreen({super.key});

  @override
  State<OnboardingSuccessScreen> createState() =>
      _OnboardingSuccessScreenState();
}

class _OnboardingSuccessScreenState extends State<OnboardingSuccessScreen> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  void _checkStatus() async {
    await _authController.fetchUserProfile();
    final rider = _authController.user.value;
    if (rider != null && rider.verified == true) {
      Get.offAllNamed(Routes.driverDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _authController.logout();

              Get.offAllNamed(Routes.loginScreen);
            },
          ),
        ],
        title: const Text("Registration Complete"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
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
              const Text(
                "Personal Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Obx(() {
                final user = _authController.user.value;
                if (user == null) return const CircularProgressIndicator();

                return Column(
                  children: [
                    _buildReadOnlyField(
                      "Full Name",
                      "${user.firstName ?? ''} ${user.lastName ?? ''}",
                    ),
                    _buildReadOnlyField(
                      "Mobile Number",
                      user.mobileNumber ?? '',
                    ),
                    _buildReadOnlyField(
                      "WhatsApp Number",
                      user.whatsappNumber ?? '',
                    ),
                    _buildReadOnlyField("Father's Name", user.fatherName ?? ''),
                    _buildReadOnlyField("Blood Group", user.bloodGroup ?? ''),
                    _buildReadOnlyField("City", user.city ?? ''),
                    _buildReadOnlyField("Address", user.address ?? ''),
                  ],
                );
              }),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: '1234567890', // Replace with actual support number
                    );
                    if (await canLaunchUrl(launchUri)) {
                      await launchUrl(launchUri);
                    } else {
                      Get.snackbar("Error", "Could not launch support number");
                    }
                  },
                  icon: const Icon(Icons.support_agent),
                  label: const Text("Raise Concern"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    side: const BorderSide(color: Colors.red),
                    foregroundColor: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 5),
          Container(
            width: double.infinity,

            child: Text(
              value.isNotEmpty ? value : "-",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
