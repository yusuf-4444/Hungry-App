import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/auth/widgets/custom_button.dart';
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
                  Gap(7),
                  CustomText(
                    text: "Welcome Back, Discover The Fast Food",
                    color: Colors.white,
                  ),
                  Gap(55),
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
                    text: "Login",
                    onPressed: () {
                      if (globalKey.currentState!.validate()) {
                        print("Success");
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
