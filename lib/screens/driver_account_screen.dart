import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nammastore_rider/controller/auth_controller.dart';
import 'package:nammastore_rider/controller/driver_dashboard_controller.dart';
import 'package:nammastore_rider/routes/app_pages.dart';

class DriverAccountScreen extends GetView<DriverDashboardController> {
  const DriverAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- Header ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Profile Card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Profile Image with Border
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.orange.shade200,
                                width: 2,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(
                                'https://i.pravatar.cc/150?img=11', // Placeholder
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Aman Sharma",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: const [
                                          Text(
                                            "4.9",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 2),
                                          Icon(
                                            Icons.star,
                                            size: 14,
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.phone,
                                      size: 14,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "+91 9999988888",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.email_outlined,
                                      size: 14,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "loremipsum@gmail.com",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // --- Wallet Card ---
              _buildWalletCard(),
              const SizedBox(height: 20),

              // --- Options List ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Options",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildOptionTile(
                      "Delivery History",
                      Icons.history,
                      Colors.pink,
                      () => Get.toNamed(Routes.deliveryHistory),
                    ),
                    _buildOptionTile(
                      "Transaction History",
                      Icons.account_balance_wallet_outlined,
                      Colors.pink,
                      () => Get.toNamed(Routes.transactionHistory),
                    ),
                    _buildOptionTile(
                      "Edit Profile",
                      Icons.person_outline,
                      Colors.pink,
                      () {},
                    ),
                    _buildOptionTile(
                      "Allotted Area",
                      Icons.location_on_outlined,
                      Colors.pink,
                      () {},
                    ),
                    _buildOptionTile(
                      "Refer and Earn",
                      Icons.card_giftcard,
                      Colors.pink,
                      () {},
                    ),
                    _buildOptionTile(
                      "Support",
                      Icons.headset_mic_outlined,
                      Colors.pink,
                      () {},
                    ),
                    _buildOptionTile(
                      "FAQ",
                      Icons.quiz_outlined,
                      Colors.pink,
                      () {},
                    ),
                    _buildOptionTile(
                      "Terms and Conditions",
                      Icons.description_outlined,
                      Colors.pink,
                      () {},
                    ),
                    _buildOptionTile(
                      "Privacy Policy",
                      Icons.visibility_outlined,
                      Colors.pink,
                      () {},
                    ),
                    _buildOptionTile(
                      "Ask For Leave",
                      Icons.mail_outline,
                      Colors.pink,
                      () {},
                    ),
                    const SizedBox(height: 10),
                    _buildOptionTile("Log Out", Icons.logout, Colors.pink, () {
                      Get.find<AuthController>().logout();
                      Get.offAllNamed(Routes.loginScreen);
                    }),
                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    String title,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor), // Mockup shows red/pink icons
        // Actually mockup icons are outlined red/pink
        horizontalTitleGap: 15,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildWalletCard() {
    return Obx(() {
      final user = controller.authController.user.value;
      final walletBalance = user?.walletBalance ?? "0";
      final cashOnHand = user?.cashOnHand ?? "0";

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF5252), Color(0xFFFF8A80)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF5252).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "My Wallet",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Balance",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "₹$walletBalance",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.3),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Cash on Hand",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "₹$cashOnHand",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
