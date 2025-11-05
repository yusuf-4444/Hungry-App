import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/di/dependancy_injection.dart';
import 'package:hungry_app/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:hungry_app/features/auth/register/logic/cubit/register_cubit.dart';
import 'package:hungry_app/features/auth/register/logic/cubit/register_state.dart';
import 'package:hungry_app/features/auth/view/signin_view.dart';
import 'package:hungry_app/features/auth/widgets/custom_button.dart';
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
              Gap(150),
              SvgPicture.asset(
                "assets/logo/Hungry_.svg",
                color: AppColors.primaryColor,
              ),
              CustomText(text: "Welcome To Our Food App", color: Colors.black),
              Gap(50),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Gap(40),
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

                          Gap(15),
                          BlocConsumer<RegisterCubit, RegisterState>(
                            listener: (context, state) {
                              state.whenOrNull(
                                success: (data) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Account Created Successfully",
                                      ),
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return BlocProvider(
                                          create: (context) =>
                                              getIt<LoginCubit>(),
                                          child: SigninView(),
                                        );
                                      },
                                    ),
                                  );
                                },
                                failure: (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("error.. $error")),
                                  );
                                },
                              );
                            },
                            builder: (context, state) {
                              final cubit = context.read<RegisterCubit>();
                              if (state is Loading) {
                                return CircularProgressIndicator();
                              } else {
                                return CustomAuthButton(
                                  isBackgroudnGreen: true,
                                  text: "Sign Up",
                                  onPressed: () {
                                    if (globalKey.currentState!.validate()) {
                                      cubit.register(
                                        name: _name.text,
                                        email: _emailAddress.text,
                                        password: _password.text,
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          ),
                          Gap(15),
                          CustomAuthButton(
                            isBackgroudnGreen: false,
                            color: Colors.white,
                            text: "Go To Login ?",
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return BlocProvider(
                                      create: (context) => getIt<LoginCubit>(),
                                      child: SigninView(),
                                    );
                                  },
                                ),
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
