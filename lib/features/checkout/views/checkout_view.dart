import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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

  // TODO: Add your state management here
  bool isLoadingProfile = false;
  String? username;
  String? visa;
  bool hasVisa = false;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      isLoadingProfile = true;
    });

    try {
      // TODO: Fetch profile data
      // final profileData = await ProfileService.getProfile();
      // setState(() {
      //   username = profileData.data.name;
      //   visa = profileData.data.visa;
      //   hasVisa = visa != null && visa.isNotEmpty;
      //   isLoadingProfile = false;
      // });
    } catch (e) {
      setState(() {
        isLoadingProfile = false;
      });
    }
  }

  SaveOrder _saveOrder() {
    return SaveOrder(items: widget.orderItems);
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoadingProfile,
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(5),
              const CustomText(
                text: "Order summary",
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              CustomOrderSummary(
                order: widget.price,
                taxes: 5,
                deliveryFees: 20.5,
                total: widget.price + 5 + 20.5,
              ),
              const Gap(30),
              const CustomText(
                text: "Payment methods",
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              const Gap(10),

              // Cash on Delivery Option
              ListTile(
                onTap: () {
                  setState(() {
                    selectedMethod = "Cash";
                  });
                },
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(14),
                ),
                tileColor: const Color(0xff3C2F2F),
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade900,
                  child: const CustomText(text: "\$", color: Colors.white),
                ),
                horizontalTitleGap: 30,
                title: const CustomText(
                  text: "Cash on Delivery",
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
                trailing: RadioGroup<String>(
                  groupValue: selectedMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedMethod = value!;
                    });
                  },
                  child: const Radio(value: "Cash", activeColor: Colors.white),
                ),
              ),
              const Gap(15),

              // Visa Option (if available)
              if (hasVisa)
                ListTile(
                  onTap: () {
                    setState(() {
                      selectedMethod = "Visa";
                    });
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(14),
                  ),
                  tileColor: Colors.blue.shade900,
                  leading: const Icon(
                    CupertinoIcons.creditcard,
                    color: Colors.white,
                  ),
                  horizontalTitleGap: 30,
                  title: const CustomText(
                    text: "Debit card",
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                  subtitle: CustomText(text: visa ?? "", color: Colors.white),
                  trailing: RadioGroup<String>(
                    groupValue: selectedMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedMethod = value!;
                      });
                    },
                    child: const Radio(
                      value: "Visa",
                      activeColor: Colors.white,
                    ),
                  ),
                ),

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
                  const CustomText(
                    text: "Save card details for future payments",
                    color: Color(0xff808080),
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
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
  }
}
