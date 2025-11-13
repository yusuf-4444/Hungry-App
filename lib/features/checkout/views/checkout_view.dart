import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_cubit.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_state.dart';
import 'package:hungry_app/features/checkout/data/models/save_order.dart';
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

  @override
  void initState() {
    super.initState();
  }

  SaveOrder _saveOrder() {
    return SaveOrder(items: widget.orderItems);
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
            bottomSheet: CustomBottomSheet(
              totalPrice: widget.price,
              saveOrder: _saveOrder(),
            ),
          ),
        );
      },
    );
  }
}
