import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/route/app_routes.dart';
import 'package:hungry_app/features/auth/login/logic/cubit/auto_login_cubit.dart';
import 'package:hungry_app/features/auth/login/logic/cubit/auto_login_state.dart';
import 'package:hungry_app/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:hungry_app/features/auth/login/logic/cubit/login_state.dart'
    as login_state;
import 'package:hungry_app/features/auth/widgets/custom_button.dart';
import 'package:hungry_app/root.dart';
import 'package:hungry_app/shared/custom_snack_bar.dart';
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
                const Gap(150),
                SvgPicture.asset(
                  "assets/logo/Hungry_.svg",
                  color: AppColors.primaryColor,
                ),
                const Gap(7),
                const CustomText(
                  text: "Welcome Back, Discover The Fast Food",
                  color: AppColors.primaryColor,
                ),
                const Gap(100),
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
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Gap(20),
                            CustomTextField(
                              controller: _emailAddress,
                              hintText: "Email Address",
                              isPassword: false,
                            ),
                            const Gap(20),
                            CustomTextField(
                              controller: _password,
                              hintText: "Password",
                              isPassword: true,
                            ),
                            const Gap(30),
                            BlocConsumer<LoginCubit, login_state.LoginState>(
                              bloc: context.read<LoginCubit>(),
                              listenWhen: (previous, current) =>
                                  current is login_state.Success ||
                                  current is login_state.Failure,
                              listener: (context, state) {
                                if (state is login_state.Failure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackBar(state.error, Colors.red),
                                  );
                                } else if (state is login_state.Success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackBar(
                                      "LOGGED IN SUCCESSFULLY",
                                      Colors.white,
                                    ),
                                  );
                                  if (!mounted) return;
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Root(),
                                    ),
                                  );
                                }
                              },
                              buildWhen: (previous, current) =>
                                  current is login_state.Loading ||
                                  current is login_state.Success ||
                                  current is login_state.Failure,
                              builder: (context, state) {
                                if (state is login_state.Loading) {
                                  return const CustomAuthButton(
                                    text: "Logging",
                                    isBackgroudnGreen: false,
                                    onPressed: null,
                                    color: Colors.white,
                                  );
                                }

                                return CustomAuthButton(
                                  isBackgroudnGreen: true,
                                  color: AppColors.primaryColor,
                                  text: "Login",
                                  onPressed: () async {
                                    if (globalKey.currentState!.validate()) {
                                      final loginCubit = context
                                          .read<LoginCubit>();
                                      await loginCubit.login(
                                        email: _emailAddress.text,
                                        password: _password.text,
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                            const Gap(10),
                            CustomAuthButton(
                              isBackgroudnGreen: false,
                              color: Colors.white,
                              text: "Create Account ?",
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.register,
                                  (_) => false,
                                );
                              },
                            ),
                            const Gap(10),
                            BlocConsumer<AutoLoginCubit, AutoLoginState>(
                              listener: (context, state) {
                                if (state is Guest && mounted) {
                                  Future.delayed(Duration.zero, () {
                                    if (mounted) {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        AppRoutes.root,
                                        (_) => false,
                                      );
                                    }
                                  });
                                }
                              },
                              builder: (context, state) {
                                final isLoading = state is Loading;
                                final cubit = context.read<AutoLoginCubit>();

                                return TextButton(
                                  onPressed: isLoading || cubit.isClosed
                                      ? null
                                      : () {
                                          if (mounted) cubit.enterAsGuest();
                                        },
                                  child: isLoading
                                      ? const CircularProgressIndicator.adaptive()
                                      : const CustomText(
                                          text: "Continue as a Guest ?",
                                          color: Colors.white,
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
      ),
    );
  }
}
