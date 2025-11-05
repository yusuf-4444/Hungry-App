import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/features/home/logic/cubit/food_cubit.dart';
import 'package:hungry_app/features/home/logic/cubit/food_state.dart';
import 'package:hungry_app/features/home/widgets/custom_food_home_widget.dart';
import 'package:hungry_app/features/home/widgets/custom_home_category.dart';
import 'package:hungry_app/features/home/widgets/custom_home_search.dart';
import 'package:hungry_app/features/home/widgets/header_profile_widget.dart';
import 'package:hungry_app/features/product/views/product_details_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List category = ["All", "Combos", "Sliders", "Classic"];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodCubit, FoodState>(
      builder: (context, state) {
        if (state is Loading) {
          return Center(child: CircularProgressIndicator());
        }
        final foods = context.read<FoodCubit>().food;
        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
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
                        HeaderProfile(name: "Yusuf Mohamed"),
                        Gap(20),
                        SearchHome(),
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
                      childCount: foods.length,
                      (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ProductDetailsView();
                                },
                              ),
                            );
                          },
                          child: CustomFoodHomeWidget(
                            image: foods[index].image,
                            title: foods[index].name,
                            subtitle: foods[index].description,
                            ratings: double.parse(foods[index].rating),
                          ),
                        );
                      },
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
