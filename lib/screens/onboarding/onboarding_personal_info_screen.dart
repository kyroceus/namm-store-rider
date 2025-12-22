import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nammastore_rider/controller/onboarding_controller.dart';

class OnboardingPersonalInfoScreen extends GetView<OnboardingController> {
  const OnboardingPersonalInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personal information",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter the details below so we can get to know\nand serve you better",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),

            _buildTextField(
              "First Name",
              controller.firstNameController,
              hint: "Please enter first name",
            ),
            _buildTextField(
              "Last Name",
              controller.lastNameController,
              hint: "Please enter last name",
            ),
            _buildTextField(
              "Father's Name",
              controller.fatherNameController,
              hint: "Please enter father's name",
            ),

            _buildLabel("Date of birth"),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  controller.dobController.text =
                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: controller.dobController,
                  decoration: _inputDecoration(
                    hint: "dd-mm-yyyy",
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            _buildTextField(
              "Primary mobile number",
              controller.mobileController,
              hint: "+91 9999988888",
              isReadOnly: true,
              fillColor: Colors.grey.shade100,
            ),
            Obx(
              () => _buildTextField(
                "WhatsApp number",
                controller.whatsAppController,
                hint: "+91 9999988888",
                isReadOnly: controller
                    .isWhatsAppSameAsMobile
                    .value, // Optional: make read-only if checked
              ),
            ),
            Obx(
              () => Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: controller.isWhatsAppSameAsMobile.value,
                      onChanged: controller.toggleWhatsAppSameAsMobile,
                      activeColor: Colors.red,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Same as primary number",
                    style: TextStyle(fontSize: 14, color: Color(0xFF424242)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            _buildTextField(
              "Blood Group",
              controller.bloodGroupController,
              hint: "Enter blood group here",
            ),
            _buildDropdownField("City", controller.cityController, [
              "Thanjavur",
              "Kumbakonam",
            ], hint: "Select City"),

            _buildLabel("Enter complete address here"),
            const SizedBox(height: 5),
            TextField(
              controller: controller.addressController,
              maxLines:
                  1, // Keep single line look or expand if needed, image shows single line height but might be multiline
              decoration: _inputDecoration(hint: "Search address"),
            ),
            const SizedBox(height: 15),

            _buildLabel("Your Profile Picture"),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                    style: BorderStyle.solid,
                  ), // Image shows dotted but solid is easier, standard dotted border needs custom painter or package. Image actually looks dotted/dashed. Using standard border for now to speed up.
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Obx(() {
                      if (controller.profileImagePath.value.isNotEmpty) {
                        return CircleAvatar(
                          radius: 30,
                          backgroundImage: FileImage(
                            File(controller.profileImagePath.value),
                          ),
                        );
                      }
                      return Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE0E0E0),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    }),
                    const SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.pickProfileImage(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red.shade100),
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                controller.profileImagePath.value.isEmpty
                                    ? Text(
                                        "Upload Photo",
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : Text(
                                        "Change Photo",
                                        style: TextStyle(color: Colors.red),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.submitPersonalInfo(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFFF8A80,
                    ), // Light red/pinkish from image
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // Rounded pill shape
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Bottom bar indicator (mocking iOS home indicator visual if needed, but not necessary)
            Center(
              child: Container(
                height: 4,
                width: 100,
                color: Colors.grey.shade300,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    TextEditingController controller,
    List<String> items, {
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          const SizedBox(height: 8),
          ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<String>(
              value: items.contains(controller.text) ? controller.text : null,
              items: items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  controller.text = val;
                }
              },
              decoration: _inputDecoration(
                hint: hint,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 16,
                ), // Adjust to 0 horizontal because alignedDropdown adds padding
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              style: const TextStyle(fontSize: 14, color: Colors.black),
              isExpanded: true,
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.w400, // Regular weight as per image
        fontSize: 14,
        color: Color(0xFF424242), // Dark grey
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController ctrl, {
    bool isReadOnly = false,
    VoidCallback? onTap,
    String? hint,
    Widget? suffixIcon,
    Color? fillColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          const SizedBox(height: 8),
          TextField(
            controller: ctrl,
            readOnly: isReadOnly,
            onTap: onTap,
            decoration: _inputDecoration(
              hint: hint,
              suffixIcon: suffixIcon,
              fillColor: fillColor,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? hint,
    Widget? suffixIcon,
    Color? fillColor,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      filled: fillColor != null,
      fillColor: fillColor ?? Colors.white,
      suffixIcon: suffixIcon,
      contentPadding:
          contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.grey,
        ), // Focusing effect usually darker grey or primary
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
