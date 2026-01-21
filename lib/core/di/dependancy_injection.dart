import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hungry_app/core/network/api_services.dart';
import 'package:hungry_app/core/network/dio_factory.dart';
import 'package:hungry_app/features/auth/login/data/repo/login_repo.dart';
import 'package:hungry_app/features/auth/login/logic/cubit/auto_login_cubit.dart';
import 'package:hungry_app/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:hungry_app/features/auth/logout/data/repo/logout_repo.dart';
import 'package:hungry_app/features/auth/logout/logic/cubit/logout_cubit.dart';
import 'package:hungry_app/features/auth/profile/data/repo/profile_repo.dart';
import 'package:hungry_app/features/auth/profile/data/repo/update_profile_repo.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_cubit.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/update_profile_cubit.dart';
import 'package:hungry_app/features/auth/register/data/repo/register_repo.dart';
import 'package:hungry_app/features/auth/register/logic/cubit/register_cubit.dart';
import 'package:hungry_app/features/cart/data/repo/addToCartRepo/add_to_cart_repo.dart';
import 'package:hungry_app/features/cart/data/repo/deleteItem/delete_item_repo.dart';
import 'package:hungry_app/features/cart/data/repo/myCart/cart_repo.dart';
import 'package:hungry_app/features/cart/logic/addToCartCubit/add_to_cart_cubit.dart';
import 'package:hungry_app/features/cart/logic/deleteItem/delete_item_cubit.dart';
import 'package:hungry_app/features/cart/logic/getCart/get_cart_cubit.dart';
import 'package:hungry_app/features/checkout/data/repo/save_order_repo.dart';
import 'package:hungry_app/features/checkout/logic/cubit/save_order_cubit.dart';
import 'package:hungry_app/features/home/data/repo/food_repo.dart';
import 'package:hungry_app/features/home/logic/cubit/food_cubit.dart';
import 'package:hungry_app/features/product/data/repo/toppings_side_options_repo.dart';
import 'package:hungry_app/features/product/logic/cubit/side_options_cubit.dart';
import 'package:hungry_app/features/product/logic/cubit/toppings_cubit.dart';

GetIt getIt = GetIt.instance;

Future<void> setUpGetIt() async {
  // Network
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<Dio>(() => dio);
  getIt.registerLazySingleton<ApiServices>(() => ApiServices(dio));

  // Repositories
  getIt.registerLazySingleton<FoodRepo>(() => FoodRepo(apiServices: getIt()));
  getIt.registerLazySingleton<RegisterRepo>(
    () => RegisterRepo(apiServices: getIt()),
  );
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(apiServices: getIt()));
  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepo(apiServices: getIt()),
  );
  getIt.registerLazySingleton<UpdateProfileRepo>(
    () => UpdateProfileRepo(apiServices: getIt(), dio: getIt()),
  );
  getIt.registerLazySingleton<LogoutRepo>(
    () => LogoutRepo(apiServices: getIt()),
  );
  getIt.registerLazySingleton<ToppingsSideOptionsRepo>(
    () => ToppingsSideOptionsRepo(apiServices: getIt()),
  );
  getIt.registerLazySingleton<AddToCartRepo>(
    () => AddToCartRepo(apiServices: getIt()),
  );
  getIt.registerLazySingleton<CartRepo>(() => CartRepo(apiServices: getIt()));
  getIt.registerLazySingleton<DeleteItemRepo>(
    () => DeleteItemRepo(apiServices: getIt()),
  );
  getIt.registerFactory<SaveOrderRepo>(
    () => SaveOrderRepo(apiServices: getIt()),
  );

  // Cubits
  getIt.registerFactory<FoodCubit>(() => FoodCubit(getIt()));
  getIt.registerFactory<RegisterCubit>(() => RegisterCubit(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
  getIt.registerLazySingleton<ProfileCubit>(() => ProfileCubit(getIt()));
  getIt.registerFactory<UpdateProfileCubit>(() => UpdateProfileCubit(getIt()));
  getIt.registerFactory<LogoutCubit>(() => LogoutCubit(getIt()));

  getIt.registerLazySingleton<AutoLoginCubit>(
    () => AutoLoginCubit(getIt<LoginRepo>())..checkAuthStatus(),
  );

  getIt.registerLazySingleton<ToppingsCubit>(() => ToppingsCubit(getIt()));
  getIt.registerLazySingleton<SideOptionsCubit>(
    () => SideOptionsCubit(getIt()),
  );

  getIt.registerFactory<GetCartCubit>(() => GetCartCubit(getIt()));
  getIt.registerFactory<AddToCartCubit>(() => AddToCartCubit(getIt()));
  getIt.registerFactory<DeleteItemCubit>(() => DeleteItemCubit(getIt()));
  getIt.registerFactory<SaveOrderCubit>(() => SaveOrderCubit(getIt()));
}
