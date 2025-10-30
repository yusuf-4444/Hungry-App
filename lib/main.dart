import 'package:flutter/material.dart';
import 'package:hungry_app/splash.dart';

void main() {
  runApp(HungryApp());
}

class HungryApp extends StatelessWidget {
  const HungryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      title: "Hungry App",
      debugShowCheckedModeBanner: false,
      home: SplashView(),
    );
  }
}
