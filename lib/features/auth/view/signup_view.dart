import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/auth/widgets/custom_button.dart';
import 'package:hungry_app/shared/custom_text_field.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _emailAddress = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  GlobalKey<FormState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: globalKey,
            child: Column(
              children: [
                Gap(70),
                SvgPicture.asset("assets/logo/Hungry_.svg"),
                Gap(55),
                CustomTextField(
                  controller: _name,
                  hintText: "Name",
                  isPassword: false,
                ),
                Gap(15),
                CustomTextField(
                  controller: _emailAddress,
                  hintText: "Email Address",
                  isPassword: false,
                ),
                Gap(15),
                CustomTextField(
                  controller: _password,
                  hintText: "Password",
                  isPassword: true,
                ),
                Gap(15),
                CustomTextField(
                  controller: _confirmPassword,
                  hintText: "Confirm Password",
                  isPassword: true,
                ),
                Gap(15),
                Gap(15),
                CustomAuthButton(
                  text: "Sign Up",
                  onPressed: () {
                    if (globalKey.currentState!.validate()) {
                      if (_password.text == _confirmPassword.text) {
                        print("Success");
                      } else {
                        print("Confirm Password doesnot match Password");
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
