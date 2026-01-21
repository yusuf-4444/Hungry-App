import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/di/dependancy_injection.dart';
import 'package:hungry_app/features/cart/logic/addToCartCubit/add_to_cart_cubit.dart';
import 'package:hungry_app/features/home/logic/cubit/food_cubit.dart';
import 'package:hungry_app/features/home/logic/cubit/food_state.dart';
import 'package:hungry_app/features/home/widgets/custom_food_home_widget.dart';
import 'package:hungry_app/features/home/widgets/custom_home_category.dart';
import 'package:hungry_app/features/home/widgets/header_profile_widget.dart';
import 'package:hungry_app/features/product/views/product_details_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> dummyCategories = [
      "All",
      "Combos",
      "Sliders",
      "Classic",
    ];
    final List<Map<String, dynamic>> dummyFoods = [
      {
        'id': 1,
        'name': 'Cheeseburger',
        'description': 'Delicious burger',
        'image':
            'https://sonic-zdi0.onrender.com/storage/products/cheeseburger.jpg',
        'price': '50.00',
        'rating': '4.5',
      },
      {
        'id': 2,
        'name': 'Chicken Slider',
        'description': 'Tasty slider',
        'image':
            'https://sonic-zdi0.onrender.com/storage/products/cheeseburger.jpg',
        'price': '35.00',
        'rating': '4.2',
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    const HeaderProfile(),
                    SizedBox(height: 24.h),
                    CustomHomeCategory(
                      category: dummyCategories,
                      selectedIndex: 0,
                      onTap: (index) {},
                    ),
                    Gap(24.h),
                  ],
                ),
              ),
              BlocBuilder<FoodCubit, FoodState>(
                bloc: context.read<FoodCubit>(),
                buildWhen: (previous, current) =>
                    current is Loading ||
                    current is Success ||
                    current is Failure,
                builder: (context, state) {
                  if (state is Loading) {
                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(childCount: 6, (
                        context,
                        index,
                      ) {
                        return const Skeletonizer(
                          child: CustomFoodHomeWidget(
                            image: '',
                            title: 'Loading food name here',
                            subtitle:
                                'Loading description text here for the food item',
                            ratings: 4.5,
                          ),
                        );
                      }),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 0.70,
                      ),
                    );
                  } else if (state is Failure) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text('Error: ${state.error}')),
                    );
                  } else if (state is Success) {
                    final foods = state.data.data;
                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        childCount: foods.length,
                        (context, index) {
                          final food = foods[index];
                          return GestureDetector(
                            onTap: () {
                              _navigateToDetails(context, food);
                            },
                            child: CustomFoodHomeWidget(
                              image: food.image,
                              title: food.name,
                              subtitle: food.description,
                              ratings: double.parse(food.rating),
                            ),
                          );
                        },
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 0.70,
                      ),
                    );
                  } else {
                    return const SliverToBoxAdapter(
                      child: Center(child: Text('No data available')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context, Map<String, dynamic> food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt<AddToCartCubit>()),
          ],
          child: ProductDetailsView(
            productId: food['id'],
            price: food['price'],
          ),
        ),
      ),
    );
  }
}
