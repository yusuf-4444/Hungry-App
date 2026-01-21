import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/route/app_routes.dart';
import 'package:hungry_app/features/auth/register/logic/cubit/register_cubit.dart';
import 'package:hungry_app/features/auth/register/logic/cubit/register_state.dart';
import 'package:hungry_app/features/auth/widgets/custom_button.dart';
import 'package:hungry_app/shared/custom_snack_bar.dart';
import 'package:hungry_app/shared/custom_text.dart';
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
  GlobalKey<FormState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: globalKey,
          child: Column(
            children: [
              const Gap(150),
              SvgPicture.asset(
                "assets/logo/Hungry_.svg",
                color: AppColors.primaryColor,
              ),
              const CustomText(
                text: "Welcome To Our Food App",
                color: Colors.black,
              ),
              const Gap(50),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Gap(40),
                          CustomTextField(
                            controller: _name,
                            hintText: "Name",
                            isPassword: false,
                          ),
                          const Gap(15),
                          CustomTextField(
                            controller: _emailAddress,
                            hintText: "Email Address",
                            isPassword: false,
                          ),
                          const Gap(15),
                          CustomTextField(
                            controller: _password,
                            hintText: "Password",
                            isPassword: true,
                          ),
                          const Gap(15),
                          const Gap(15),
                          BlocConsumer<RegisterCubit, RegisterState>(
                            listenWhen: (previous, current) =>
                                current is Failure || current is Success,
                            listener: (context, state) {
                              if (state is Success) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.login,
                                  (_) => false,
                                );
                              } else if (state is Failure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackBar(state.error, Colors.red),
                                );
                              }
                            },
                            buildWhen: (previous, current) =>
                                current is Loading ||
                                current is Failure ||
                                current is Success,
                            builder: (context, state) {
                              if (state is Loading) {
                                return const CustomAuthButton(
                                  onPressed: null,
                                  text: "Signing Up...",
                                  isBackgroudnGreen: true,
                                );
                              }
                              return CustomAuthButton(
                                isBackgroudnGreen: true,
                                text: "Sign Up",
                                onPressed: () {
                                  if (globalKey.currentState!.validate()) {
                                    context.read<RegisterCubit>().register(
                                      name: _name.text,
                                      email: _emailAddress.text,
                                      password: _password.text,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                          const Gap(15),
                          CustomAuthButton(
                            isBackgroudnGreen: false,
                            color: Colors.white,
                            text: "Go To Login ?",
                            onPressed: () {
                              _emailAddress.clear();
                              _password.clear();
                              _name.clear();
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.login,
                                (_) => false,
                              );
                            },
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
    );
  }
}
