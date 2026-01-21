import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/di/dependancy_injection.dart';
import 'package:hungry_app/core/route/app_routes.dart';
import 'package:hungry_app/features/auth/login/logic/cubit/auto_login_cubit.dart';
import 'package:hungry_app/features/auth/logout/logic/cubit/logout_cubit.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_cubit.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/update_profile_cubit.dart';
import 'package:hungry_app/features/auth/register/logic/cubit/register_cubit.dart';
import 'package:hungry_app/features/auth/view/profile_view.dart';
import 'package:hungry_app/features/auth/view/signin_view.dart';
import 'package:hungry_app/features/auth/view/signup_view.dart';
import 'package:hungry_app/features/cart/logic/addToCartCubit/add_to_cart_cubit.dart';
import 'package:hungry_app/features/home/views/home_view.dart';
import 'package:hungry_app/features/product/logic/cubit/side_options_cubit.dart';
import 'package:hungry_app/features/product/logic/cubit/toppings_cubit.dart';
import 'package:hungry_app/features/product/views/product_details_view.dart';
import 'package:hungry_app/root.dart';
import 'package:hungry_app/splash.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return CupertinoPageRoute(builder: (_) => const HomeView());
      case AppRoutes.splash:
        return CupertinoPageRoute(builder: (_) => const SplashView());
      case AppRoutes.login:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AutoLoginCubit>(),
            child: const SigninView(),
          ),
        );
      case AppRoutes.profile:
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<LogoutCubit>()),
              BlocProvider.value(value: getIt<ProfileCubit>()..getProfile()),
              BlocProvider(create: (context) => getIt<UpdateProfileCubit>()),
            ],
            child: const ProfileView(),
          ),
        );
      case AppRoutes.root:
        return CupertinoPageRoute(builder: (_) => const Root());
      case AppRoutes.register:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<RegisterCubit>(),
            child: const SignupView(),
          ),
        );
      case AppRoutes.productDetails:
        final foodItem = settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<AddToCartCubit>()),
              BlocProvider.value(
                value: getIt<SideOptionsCubit>()..getSideOptions(),
              ),
              BlocProvider.value(value: getIt<ToppingsCubit>()..getToppings()),
            ],
            child: ProductDetailsView(
              productId: foodItem['productId'],
              price: foodItem['price'],
            ),
          ),
        );
      default:
        return CupertinoPageRoute(builder: (_) => const SplashView());
    }
  }
}
