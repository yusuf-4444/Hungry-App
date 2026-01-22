import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/route/app_routes.dart';
import 'package:hungry_app/features/home/logic/cubit/food_cubit.dart';
import 'package:hungry_app/features/home/logic/cubit/food_state.dart';
import 'package:hungry_app/features/home/widgets/custom_food_home_widget.dart';
import 'package:hungry_app/features/home/widgets/custom_home_category.dart';
import 'package:hungry_app/features/home/widgets/custom_home_search.dart';
import 'package:hungry_app/features/home/widgets/header_profile_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedCategoryIndex = 0;
  final List<String> categories = ["All", "Combos", "Sliders", "Classic"];

  @override
  void initState() {
    super.initState();
  }

  void _onCategorySelected(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });
    context.read<FoodCubit>().filterByCategory(categories[index]);
  }

  void _onSearchChanged(String query) {
    context.read<FoodCubit>().searchFood(query);
  }

  @override
  Widget build(BuildContext context) {
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

                    SearchHome(onChanged: _onSearchChanged),
                    SizedBox(height: 24.h),

                    CustomHomeCategory(
                      category: categories,
                      selectedIndex: selectedCategoryIndex,
                      onTap: _onCategorySelected,
                    ),
                    Gap(24.h),
                  ],
                ),
              ),

              // Food Grid
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
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const Gap(16),
                            Text('Error: ${state.error}'),
                            const Gap(16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<FoodCubit>().refreshFood();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is Success) {
                    final foods = state.data.data;

                    if (foods.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Gap(40),
                              const Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const Gap(16),
                              Text(
                                'No items found',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              const Gap(8),
                              Text(
                                'Try searching with different keywords',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

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

  void _navigateToDetails(BuildContext context, dynamic food) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => MultiBlocProvider(
    //       providers: [
    //         BlocProvider(create: (context) => getIt<AddToCartCubit>()),
    //       ],
    //       child: ProductDetailsView(productId: food.id, price: food.price),
    //     ),
    //   ),
    // );
    Navigator.pushNamed(
      context,
      AppRoutes.productDetails,
      arguments: {'productId': food.id, 'price': food.price},
    );
  }
}
