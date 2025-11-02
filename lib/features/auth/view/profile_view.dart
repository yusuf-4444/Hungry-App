import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/auth/widgets/custom_text_form_field.dart';
import 'package:hungry_app/shared/custom_text.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();

  final TextEditingController _address = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings, color: Colors.white),
          ),
        ],
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(10),
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    border: Border.all(width: 3, color: Colors.white),
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              Gap(35),
              CustomTextFormField(controller: _name, labelText: 'Name'),
              Gap(20),
              CustomTextFormField(controller: _email, labelText: 'Email'),
              Gap(20),
              CustomTextFormField(
                controller: _address,
                labelText: 'Delivary Address',
              ),
              Gap(20),
              CustomTextFormField(controller: _password, labelText: 'Password'),
              Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(),
              ),
              Gap(20),

              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(14),
                ),
                tileColor: Colors.white,
                leading: Image.asset("assets/profileIcons/image 13.png"),
                horizontalTitleGap: 30,
                title: CustomText(
                  text: "Debit card",
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontsize: 14,
                ),
                subtitle: CustomText(
                  text: "3566 **** **** 0505",
                  color: Colors.black,
                ),
                trailing: CustomText(text: "Default", color: Colors.black),
              ),
              Gap(100),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 70,
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    CustomText(text: "Edit Profile", color: Colors.white),
                    Gap(10),
                    Icon(Icons.edit, color: Colors.white),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    CustomText(text: "Logout", color: Colors.black),
                    Gap(10),
                    Icon(Icons.logout, color: Colors.black),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
