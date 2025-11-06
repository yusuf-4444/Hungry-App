import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/di/dependancy_injection.dart';
import 'package:hungry_app/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:hungry_app/features/auth/login/logic/cubit/login_state.dart';
import 'package:hungry_app/features/auth/register/logic/cubit/register_cubit.dart';
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
                            BlocConsumer<LoginCubit, LoginState>(
                              listener: (context, state) {
                                state.whenOrNull(
                                  success: (data) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Success Login !"),
                                      ),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return Root();
                                        },
                                      ),
                                    );
                                  },
                                  failure: (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        clipBehavior: Clip.none,
                                        elevation: 15,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.red.shade800,
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.info,
                                              color: Colors.white,
                                            ),
                                            Center(
                                              child: CustomText(
                                                text: error,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              builder: (context, state) {
                                final cubit = context.read<LoginCubit>();
                                if (state is Loading) {
                                  return CupertinoActivityIndicator(
                                    color: Colors.white,
                                  );
                                }
                                return CustomAuthButton(
                                  isBackgroudnGreen: true,
                                  color: AppColors.primaryColor,
                                  text: "Login",
                                  onPressed: () {
                                    if (globalKey.currentState!.validate()) {
                                      cubit.login(
                                        email: _emailAddress.text,
                                        password: _password.text,
                                      );
                                    }
                                  },
                                );
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
                                      return BlocProvider(
                                        create: (context) =>
                                            getIt<RegisterCubit>(),
                                        child: SignupView(),
                                      );
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
