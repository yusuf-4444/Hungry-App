import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
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
                delegate: SliverChildBuilderDelegate(childCount: 6, (
                  context,
                  index,
                ) {
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
                      image: 'assets/test/test.png',
                      title: 'Cheeseburger',
                      subtitle: "Wendy's Burger",
                      ratings: 4.9,
                    ),
                  );
                }),
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
  }
}
