import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/di/dependancy_injection.dart';
import 'package:hungry_app/core/network/pref_helper.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_cubit.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_state.dart';
import 'package:hungry_app/features/checkout/data/models/save_order.dart';
import 'package:hungry_app/features/checkout/logic/cubit/save_order_cubit.dart';
import 'package:hungry_app/features/checkout/widgets/custom_bottom_sheet.dart';
import 'package:hungry_app/features/checkout/widgets/custom_order_summary.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({
    super.key,
    required this.price,
    required this.orderItems,
  });

  final double price;
  final List<OrderItems> orderItems;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String selectedMethod = "Cash";
  bool isChecked = true;
  bool isGuestMode = false;

  bool isLoadingProfile = false;
  String? username;
  String? visa;
  bool hasVisa = false;

  @override
  void initState() {
    super.initState();
    _checkGuestMode();
    _fetchProfile();
  }

  Future<void> _checkGuestMode() async {
    final guest = await PrefHelper.isGuest();
    if (mounted) {
      setState(() {
        isGuestMode = guest;
      });
    }
  }

  Future<void> _fetchProfile() async {
    if (isGuestMode) {
      setState(() {
        isLoadingProfile = false;
        username = "Guest";
        hasVisa = false;
      });
      return;
    }

    setState(() {
      isLoadingProfile = true;
    });

    final profileCubit = context.read<ProfileCubit>();
    final currentState = profileCubit.state;

    if (currentState is Success) {
      final profileData = currentState.data;
      setState(() {
        username = profileData.data.name;
        visa = profileData.data.visa;
        hasVisa = visa != null && visa!.isNotEmpty;
        isLoadingProfile = false;
      });
    } else {
      await profileCubit.getProfile();
    }
  }

  SaveOrder _createSaveOrder() {
    return SaveOrder(items: widget.orderItems);
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SaveOrderCubit>(),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is Success) {
            final profileData = state.data;
            setState(() {
              username = profileData.data.name;
              visa = profileData.data.visa;
              hasVisa = visa != null && visa!.isNotEmpty;
              isLoadingProfile = false;
            });
          }
        },
        child: Skeletonizer(
          enabled: isLoadingProfile,
          child: Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  fontWeight: FontWeight.bold,
                  size: 24.sp,
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(5.h),
                  CustomText(
                    text: "Order summary",
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                  CustomOrderSummary(
                    order: widget.price,
                    taxes: 5,
                    deliveryFees: 20.5,
                    total: widget.price + 5 + 20.5,
                  ),
                  Gap(30.h),
                  CustomText(
                    text: "Payment methods",
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                  Gap(10.h),

                  _buildPaymentOption(
                    title: "Cash on Delivery",
                    value: "Cash",
                    color: const Color(0xff3C2F2F),
                    icon: CircleAvatar(
                      backgroundColor: const Color(0xff1B5E20),
                      radius: 20.r,
                      child: CustomText(
                        text: "\$",
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  Gap(15.h),

                  if (hasVisa && !isGuestMode)
                    _buildPaymentOption(
                      title: "Debit card",
                      subtitle: _formatVisaNumber(visa!),
                      value: "Visa",
                      color: const Color(0xff1565C0),
                      icon: Icon(
                        CupertinoIcons.creditcard,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),

                  if (!isGuestMode)
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.red,
                          value: isChecked,
                          onChanged: (v) {
                            setState(() {
                              isChecked = v!;
                            });
                          },
                        ),
                        Expanded(
                          child: CustomText(
                            text: "Save card details for future payments",
                            color: const Color(0xff808080),
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            bottomSheet: CustomBottomSheet(
              orderItems: widget.orderItems,
              totalPrice: widget.price,
              saveOrder: _createSaveOrder(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    String? subtitle,
    required String value,
    required Color color,
    required Widget icon,
  }) {
    return ListTile(
      onTap: () {
        setState(() {
          selectedMethod = value;
        });
      },
      contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      tileColor: color,
      leading: icon,
      horizontalTitleGap: 30.w,
      title: CustomText(
        text: title,
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 17.sp,
      ),
      subtitle: subtitle != null
          ? CustomText(
              text: subtitle,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            )
          : null,
      trailing: RadioGroup<String>(
        groupValue: selectedMethod,
        onChanged: (newValue) {
          setState(() {
            selectedMethod = newValue!;
          });
        },
        child: Radio(value: value, activeColor: Colors.white),
      ),
    );
  }
}
