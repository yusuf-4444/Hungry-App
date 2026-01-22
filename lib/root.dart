import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/di/dependancy_injection.dart';
import 'package:hungry_app/features/auth/logout/logic/cubit/logout_cubit.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_cubit.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/update_profile_cubit.dart';
import 'package:hungry_app/features/auth/view/profile_view.dart';
import 'package:hungry_app/features/cart/logic/deleteItem/delete_item_cubit.dart';
import 'package:hungry_app/features/cart/views/cart_view.dart';
import 'package:hungry_app/features/home/views/home_view.dart';
import 'package:hungry_app/features/orderHistory/views/order_histroy_view.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int currentPage = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      const HomeView(),
      const CartView(),
      const OrderHistroyView(),
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<LogoutCubit>()),
          BlocProvider.value(value: getIt<ProfileCubit>()..getProfile()),
          BlocProvider(create: (context) => getIt<UpdateProfileCubit>()),
          BlocProvider(create: (context) => getIt<DeleteItemCubit>()),
        ],
        child: const ProfileView(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentPage, children: _pages),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
          color: AppColors.primaryColor,
        ),
        child: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              currentPage = value;
            });
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade700,
          elevation: 0,
          backgroundColor: Colors.transparent,
          currentIndex: currentPage,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12.sp,
          unselectedFontSize: 10.sp,
          iconSize: 24.sp,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.cart),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_restaurant_sharp),
              label: "Order History",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.profile_circled),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
