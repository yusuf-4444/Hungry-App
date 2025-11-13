import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/di/dependancy_injection.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_cubit.dart';
import 'package:hungry_app/features/cart/logic/addToCartCubit/add_to_cart_cubit.dart';
import 'package:hungry_app/features/home/data/models/food_data_model.dart';
import 'package:hungry_app/features/home/logic/cubit/food_cubit.dart';
import 'package:hungry_app/features/home/logic/cubit/food_state.dart';
import 'package:hungry_app/features/home/widgets/custom_food_home_widget.dart';
import 'package:hungry_app/features/home/widgets/custom_home_category.dart';
import 'package:hungry_app/features/home/widgets/custom_home_search.dart';
import 'package:hungry_app/features/home/widgets/header_profile_widget.dart';
import 'package:hungry_app/features/product/views/product_details_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List category = ["All", "Combos", "Sliders", "Classic"];
  List<Data> filterFood = [];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodCubit, FoodState>(
      builder: (context, state) {
        final foods = context.read<FoodCubit>().food;
        if (filterFood.isEmpty && foods.isNotEmpty) {
          filterFood = foods;
        }
        final isLoading = state is Loading;

        if (state is Failure && (foods.isEmpty)) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.error.toString()),
                ElevatedButton(
                  onPressed: () {
                    context.read<FoodCubit>().refreshFood();
                  },
                  child: Text("Retry"),
                ),
              ],
            ),
          );
        }

        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<FoodCubit>().refreshFood();
              await context.read<ProfileCubit>().refreshProfile();
            },
            child: Skeletonizer(
              enabled: isLoading,
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 0,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  surfaceTintColor: Colors.white,
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        pinned: true,
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        surfaceTintColor: Colors.white,
                        scrolledUnderElevation: 0,
                        toolbarHeight: 230,
                        flexibleSpace: Column(
                          children: [
                            Gap(25),
                            HeaderProfile(),
                            Gap(20),
                            SearchHome(
                              onChanged: (v) {
                                filterFood = foods.where((food) {
                                  final title = food.name.toLowerCase();
                                  final input = v.toLowerCase();
                                  return title.contains(input);
                                }).toList();
                                setState(() {});
                              },
                            ),
                            Gap(20),
                            CustomHomeCategory(
                              category: category,
                              selectedIndex: selectedIndex,
                            ),
                          ],
                        ),
                      ),
                      SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          childCount: isLoading ? 6 : filterFood.length,
                          (context, index) {
                            if (isLoading) {
                              return CustomFoodHomeWidget(
                                image:
                                    "https://sonic-zdi0.onrender.com/storage/products/cheeseburger.jpg",
                                title: "Loading...",
                                subtitle: "Loading...",
                                ratings: 0.0,
                              );
                            } else {
                              final food = filterFood[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return MultiBlocProvider(
                                          providers: [
                                            BlocProvider(
                                              create: (context) =>
                                                  getIt<AddToCartCubit>(),
                                            ),
                                          ],
                                          child: ProductDetailsView(
                                            productId: food.id,
                                            price: food.price,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: CustomFoodHomeWidget(
                                  image: food.image,
                                  title: food.name,
                                  subtitle: food.description,
                                  ratings: double.parse(food.rating),
                                ),
                              );
                            }
                          },
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.67,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
