import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_cubit.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_state.dart';
import 'package:hungry_app/features/checkout/widgets/custom_order_summary.dart';
import 'package:hungry_app/shared/custom_main_button.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key, required this.price});

  final double price;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String selectedMethod = "Cash";
  bool isChecked = true;
  dynamic cubit;

  @override
  void initState() {
    context.read<ProfileCubit>().getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profileData = state is Success ? state.data : null;
        final hasVisa = profileData?.data!.visa != null;
        return Skeletonizer(
          enabled: state is Loading,
          child: Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, fontWeight: FontWeight.bold),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(5),
                  CustomText(
                    text: "Order summary",
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontsize: 18,
                  ),
                  CustomOrderSummary(
                    order: widget.price,
                    taxes: 5,
                    deliveryFees: 20.5,
                    total: widget.price + 5 + 20.5,
                  ),
                  Gap(30),
                  CustomText(
                    text: "Payment methods",
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontsize: 18,
                  ),
                  Gap(10),
                  ListTile(
                    onTap: () {
                      selectedMethod = "Cash";
                      setState(() {});
                    },
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(14),
                    ),
                    tileColor: Color(0xff3C2F2F),
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade900,
                      child: CustomText(text: "\$", color: Colors.white),
                    ),
                    horizontalTitleGap: 30,
                    title: CustomText(
                      text: "Cash on Delivery",
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontsize: 17,
                    ),
                    // ignore: deprecated_member_use
                    trailing: RadioGroup<String>(
                      groupValue: selectedMethod,
                      onChanged: (value) {
                        selectedMethod = value!;
                        setState(() {});
                      },
                      child: Radio(value: "Cash", activeColor: Colors.white),
                    ),
                  ),
                  Gap(15),

                  if (hasVisa)
                    ListTile(
                      onTap: () {
                        selectedMethod = "Visa";
                        setState(() {});
                      },
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(14),
                      ),
                      tileColor: Colors.blue.shade900,
                      leading: Icon(
                        CupertinoIcons.creditcard,
                        color: Colors.white,
                      ),

                      horizontalTitleGap: 30,
                      title: CustomText(
                        text: "Debit card",
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontsize: 14,
                      ),
                      subtitle: CustomText(
                        text: profileData.data.visa,
                        color: Colors.white,
                      ),
                      trailing: RadioGroup<String>(
                        groupValue: selectedMethod,
                        onChanged: (value) {
                          selectedMethod = value!;
                          setState(() {});
                        },
                        child: Radio(value: "Visa", activeColor: Colors.white),
                      ),
                    ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.red,
                        value: isChecked,
                        onChanged: (v) {
                          isChecked = v!;
                          setState(() {});
                        },
                      ),
                      CustomText(
                        text: "Save card details for future payments",
                        color: Color(0xff808080),
                        fontWeight: FontWeight.w400,
                        fontsize: 13,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            bottomSheet: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade800, blurRadius: 8),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(13),
                        CustomText(
                          text: "Total",
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontsize: 14,
                        ),
                        Gap(10),
                        CustomText(
                          text: "\$ ${widget.price + 5 + 20.5}",
                          color: Colors.black,
                          fontsize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ],
                    ),
                    CustomMainButton(
                      text: "Pay Now",
                      fontSize: 16,
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return Dialog(
                              insetPadding: EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 200,
                              ),
                              backgroundColor: Colors.white,
                              child: Column(
                                children: [
                                  Gap(15),
                                  CircleAvatar(
                                    radius: 33,
                                    backgroundColor: AppColors.primaryColor,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      size: 40,
                                    ),
                                  ),
                                  Gap(30),
                                  CustomText(
                                    text: "Success !",
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontsize: 25,
                                  ),
                                  Gap(15),
                                  CustomText(
                                    text:
                                        "Your payment was successful\n.A receipt for this purchase has\n been sent to your email.",
                                    color: Color(0xffBCBBBB),
                                    fontWeight: FontWeight.w400,
                                    fontsize: 14,
                                    textAlign: TextAlign.center,
                                  ),
                                  Spacer(),
                                  CustomMainButton(
                                    text: "Go Back",
                                    fontSize: 15,
                                    width: 200,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Gap(10),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
