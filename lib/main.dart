import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hungry_app/features/auth/view/signin_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(HungryApp());
}

class HungryApp extends StatelessWidget {
  const HungryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        splashColor: Colors.transparent,
      ),
      title: "Hungry App",
      debugShowCheckedModeBanner: false,
      home: SigninView(),
    );
  }
}
