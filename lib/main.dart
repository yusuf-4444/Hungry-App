import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/di/dependancy_injection.dart';
import 'package:hungry_app/features/home/logic/cubit/food_cubit.dart';
import 'package:hungry_app/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setUpGetIt();
  runApp(HungryApp());
}

class HungryApp extends StatelessWidget {
  const HungryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FoodCubit>()..getFood(),
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          splashColor: Colors.transparent,
        ),
        title: "Hungry App",
        debugShowCheckedModeBanner: false,
        home: SplashView(),
      ),
    );
  }
}
