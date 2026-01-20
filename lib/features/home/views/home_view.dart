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

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<String> _categories = ["All", "Combos", "Sliders", "classic"];
  List<Data> _filteredFood = [];
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodCubit, FoodState>(
      builder: (context, state) {
        return _buildContent(state);
      },
    );
  }

  Widget _buildContent(FoodState state) {
    if (state is Failure && _filteredFood.isEmpty) {
      return _buildErrorView(state.error);
    }

    final foods = context.read<FoodCubit>().food;
    if (_filteredFood.isEmpty && foods.isNotEmpty) {
      _filteredFood = foods;
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _buildScaffold(state is Loading, foods),
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<FoodCubit>().refreshFood(),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildScaffold(bool isLoading, List<Data> foods) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: CustomScrollView(
          slivers: [_buildStickyHeader(), _buildFoodGrid(isLoading, foods)],
        ),
      ),
    );
  }

  SliverAppBar _buildStickyHeader() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      pinned: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.white,
      scrolledUnderElevation: 0,
      toolbarHeight: 230,
      flexibleSpace: Column(
        children: [
          const Gap(25),
          const HeaderProfile(),
          const Gap(20),
          SearchHome(onChanged: _handleSearch),
          const Gap(20),
          CustomHomeCategory(
            category: _categories,
            selectedIndex: _selectedCategoryIndex,
            onTap: _handleCategorySelection,
          ),
        ],
      ),
    );
  }

  SliverGrid _buildFoodGrid(bool isLoading, List<Data> foods) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        childCount: isLoading ? 6 : _filteredFood.length,
        (context, index) => _buildFoodItem(isLoading, index),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.67,
      ),
    );
  }

  Widget _buildFoodItem(bool isLoading, int index) {
    if (isLoading) {
      return const CustomFoodHomeWidget(
        image:
            "https://sonic-zdi0.onrender.com/storage/products/cheeseburger.jpg",
        title: "Loading...",
        subtitle: "Loading...",
        ratings: 0.0,
      );
    }

    final food = _filteredFood[index];
    return GestureDetector(
      onTap: () => _navigateToProductDetails(food),
      child: CustomFoodHomeWidget(
        image: food.image,
        title: food.name,
        subtitle: food.description,
        ratings: double.parse(food.rating),
      ),
    );
  }

  // Event Handlers
  void _handleSearch(String query) {
    final foods = context.read<FoodCubit>().food;
    setState(() {
      _filteredFood = foods.where((food) {
        return food.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _handleCategorySelection(int index) {
    final foods = context.read<FoodCubit>().food;
    setState(() {
      _selectedCategoryIndex = index;

      if (index == 0) {
        _filteredFood = foods;
      } else {
        final selectedCategory = _categories[index];
        _filteredFood = foods.where((food) {
          return food.name.toLowerCase().contains(
            selectedCategory.toLowerCase(),
          );
        }).toList();
      }
    });
  }

  Future<void> _handleRefresh() async {
    await context.read<FoodCubit>().refreshFood();
    await context.read<ProfileCubit>().refreshProfile();
  }

  void _navigateToProductDetails(Data food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [BlocProvider(create: (_) => getIt<AddToCartCubit>())],
          child: ProductDetailsView(productId: food.id, price: food.price),
        ),
      ),
    );
  }
}
