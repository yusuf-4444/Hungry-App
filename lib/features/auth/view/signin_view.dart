import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                Gap(150.h),
                SvgPicture.asset(
                  "assets/logo/Hungry_.svg",
                  color: AppColors.primaryColor,
                  height: 50.h,
                ),
                Gap(7.h),
                CustomText(
                  text: "Welcome Back, Discover The Fast Food",
                  color: AppColors.primaryColor,
                  fontSize: 14.sp,
                ),
                Gap(100.h),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Gap(20.h),
                            CustomTextField(
                              controller: _emailAddress,
                              hintText: "Email Address",
                              isPassword: false,
                            ),
                            Gap(20.h),
                            CustomTextField(
                              controller: _password,
                              hintText: "Password",
                              isPassword: true,
                            ),
                            Gap(30.h),
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
                            Gap(10.h),
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
                            Gap(10.h),
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
                                      : CustomText(
                                          text: "Continue as a Guest ?",
                                          color: Colors.white,
                                          fontSize: 14.sp,
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
