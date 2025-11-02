import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/auth/view/signup_view.dart';
import 'package:hungry_app/features/auth/widgets/custom_button.dart';
import 'package:hungry_app/root.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:hungry_app/shared/custom_text_field.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final TextEditingController _emailAddress = TextEditingController();
  final TextEditingController _password = TextEditingController();
  GlobalKey<FormState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Form(
            key: globalKey,
            child: Column(
              children: [
                Gap(150),
                SvgPicture.asset(
                  "assets/logo/Hungry_.svg",
                  color: AppColors.primaryColor,
                ),
                Gap(7),
                CustomText(
                  text: "Welcome Back, Discover The Fast Food",
                  color: AppColors.primaryColor,
                ),
                Gap(100),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Gap(20),
                            CustomTextField(
                              controller: _emailAddress,
                              hintText: "Email Address",
                              isPassword: false,
                            ),
                            Gap(20),
                            CustomTextField(
                              controller: _password,
                              hintText: "Password",
                              isPassword: true,
                            ),
                            Gap(30),
                            CustomAuthButton(
                              isBackgroudnGreen: true,
                              color: AppColors.primaryColor,
                              text: "Login",
                              onPressed: () {
                                if (globalKey.currentState!.validate()) {
                                  print("Success");
                                }
                              },
                            ),
                            Gap(10),
                            CustomAuthButton(
                              isBackgroudnGreen: false,
                              color: Colors.white,
                              text: "Create Account ?",
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SignupView();
                                    },
                                  ),
                                );
                              },
                            ),
                            Gap(10),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Root();
                                    },
                                  ),
                                );
                              },
                              child: CustomText(
                                text: "Continue as a Guest ?",
                                color: Colors.white,
                              ),
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
      ),
    );
  }
}
