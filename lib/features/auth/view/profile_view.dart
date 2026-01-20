import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/auth/view/signin_view.dart';
import 'package:hungry_app/features/auth/widgets/custom_text_form_field.dart';
import 'package:hungry_app/shared/custom_main_button.dart';
import 'package:hungry_app/shared/custom_snack_bar.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _visa = TextEditingController();

  String? _selectedImageUrl;
  File? _selectedImageFile;
  String visa = "";
  String editProfile = "Edit Profile";
  bool _isLoading = false;

  Future<void> uploadImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImageFile = File(image.path);
        _selectedImageUrl = null;
      });
    }
  }

  String _formatVisaNumber(String visa) {
    try {
      String cleaned = visa.replaceAll(RegExp(r'[^\d]'), '');

      if (cleaned.isEmpty) return "**** **** **** ****";
      if (cleaned.length < 8) {
        return "**** **** **** ${cleaned.padLeft(4, '*')}";
      }

      String firstFour = cleaned.substring(0, 4);
      String lastFour = cleaned.substring(cleaned.length - 4);

      return '$firstFour **** **** $lastFour';
    } catch (e) {
      return "**** **** **** ****";
    }
  }

  Future<void> _editProfile() async {
    setState(() {
      _isLoading = true;
      editProfile = "Editing...";
    });

    try {
      // TODO: هنا هتتعامل مع الـ API مباشرة
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar("Updated Successfully", Colors.white));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar("Update failed", Colors.red));
    } finally {
      setState(() {
        _isLoading = false;
        editProfile = "Edit Profile";
      });
    }
  }

  Future<void> _logout() async {
    // TODO: هنا هتتعامل مع الـ logout API مباشرة
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(CustomSnackBar("LOGGED OUT SUCCESSFULLY", Colors.white));

    // TODO: هنا هتشيل التوكن من الـ SharedPreferences
    // PrefHelper.removeToken();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SigninView()),
    );
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: هنا هتجيب البيانات من الـ API مباشرة
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // Sample data - replace with actual API response
      _name.text = "John Doe";
      _email.text = "john@example.com";
      _address.text = "123 Main Street, Cairo";
      _visa.text = "1234567890123456";
      visa = _visa.text;
      _selectedImageUrl = "https://example.com/profile.jpg";
      _selectedImageFile = null;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar("Failed to load profile", Colors.red));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const Gap(10),
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border.all(width: 3, color: Colors.white),
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: _selectedImageFile != null
                              ? Image.file(
                                  _selectedImageFile!,
                                  fit: BoxFit.cover,
                                )
                              : (_selectedImageUrl != null &&
                                    _selectedImageUrl!.isNotEmpty)
                              ? Image.network(
                                  _selectedImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      "https://tse4.mm.bing.net/th/id/OIP.hGSCbXlcOjL_9mmzerqAbQHaHa?pid=Api&P=0&h=220",
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.network(
                                  "https://tse4.mm.bing.net/th/id/OIP.hGSCbXlcOjL_9mmzerqAbQHaHa?pid=Api&P=0&h=220",
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    CustomMainButton(
                      onPressed: uploadImage,
                      text:
                          _selectedImageFile == null &&
                              (_selectedImageUrl == null ||
                                  _selectedImageUrl!.isEmpty)
                          ? "Upload Image"
                          : "Change Image",
                      fontSize: 12,
                      width: 200,
                    ),
                    const Gap(10),
                    CustomTextFormField(controller: _name, labelText: 'Name'),
                    const Gap(20),
                    CustomTextFormField(controller: _email, labelText: 'Email'),
                    const Gap(20),
                    CustomTextFormField(
                      controller: _address,
                      labelText: 'Delivery Address',
                    ),
                    const Gap(20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(color: Colors.white),
                    ),
                    const Gap(20),
                    CustomTextFormField(
                      textInputType: TextInputType.number,
                      controller: _visa,
                      labelText: visa.isEmpty ? "Add Visa" : 'Edit Visa',
                    ),
                    const Gap(20),
                    visa.isEmpty
                        ? const SizedBox.shrink()
                        : ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(14),
                            ),
                            tileColor: Colors.white,
                            leading: Image.asset(
                              "assets/profileIcons/image_13.png", // Fixed asset path
                              width: 40,
                              height: 40,
                            ),
                            horizontalTitleGap: 30,
                            title: const CustomText(
                              text: "Debit card",
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontsize: 14,
                            ),
                            subtitle: CustomText(
                              text: visa.isNotEmpty
                                  ? _formatVisaNumber(visa)
                                  : "3566 **** **** 0505",
                              color: Colors.black,
                            ),
                            trailing: const CustomText(
                              text: "Default",
                              color: Colors.black,
                            ),
                          ),
                    const Gap(100),
                  ],
                ),
              ),
            ),
      bottomSheet: Container(
        height: 70,
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: _isLoading ? null : _editProfile,
              child: Container(
                decoration: BoxDecoration(
                  color: _isLoading ? Colors.grey : AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      CustomText(text: editProfile, color: Colors.white),
                      const Gap(10),
                      _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.edit, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: _logout,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      CustomText(text: "Logout", color: Colors.black),
                      Gap(10),
                      Icon(Icons.logout, color: Colors.black),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
