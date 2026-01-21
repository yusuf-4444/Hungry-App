import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/di/dependancy_injection.dart';
import 'package:hungry_app/core/route/app_routes.dart';
import 'package:hungry_app/features/auth/login/logic/cubit/auto_login_cubit.dart';
import 'package:hungry_app/features/auth/logout/logic/cubit/logout_cubit.dart';
import 'package:hungry_app/features/auth/register/logic/cubit/register_cubit.dart';
import 'package:hungry_app/features/auth/view/profile_view.dart';
import 'package:hungry_app/features/auth/view/signin_view.dart';
import 'package:hungry_app/features/auth/view/signup_view.dart';
import 'package:hungry_app/features/home/views/home_view.dart';
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
          builder: (_) => BlocProvider(
            create: (context) => getIt<LogoutCubit>(),
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
      default:
        return CupertinoPageRoute(builder: (_) => const SplashView());
    }
  }
}
