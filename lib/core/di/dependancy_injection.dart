import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hungry_app/core/network/api_services.dart';
import 'package:hungry_app/core/network/dio_factory.dart';
import 'package:hungry_app/features/auth/login/data/repo/login_repo.dart';
import 'package:hungry_app/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:hungry_app/features/auth/profile/data/repo/profile_repo.dart';
import 'package:hungry_app/features/auth/profile/data/repo/update_profile_repo.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_cubit.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/update_profile_cubit.dart';
import 'package:hungry_app/features/auth/register/data/repo/register_repo.dart';
import 'package:hungry_app/features/auth/register/logic/cubit/register_cubit.dart';
import 'package:hungry_app/features/home/data/repo/food_repo.dart';
import 'package:hungry_app/features/home/logic/cubit/food_cubit.dart';

GetIt getIt = GetIt.instance;

Future<void> setUpGetIt() async {
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<Dio>(() => dio);
  getIt.registerLazySingleton<ApiServices>(() => ApiServices(dio));

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

  getIt.registerFactory<FoodCubit>(() => FoodCubit(getIt()));
  getIt.registerFactory<RegisterCubit>(() => RegisterCubit(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt()));
  getIt.registerFactory<UpdateProfileCubit>(() => UpdateProfileCubit(getIt()));
}
