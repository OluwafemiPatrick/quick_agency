import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quickseen_agent/home/wrapper.dart';
import 'package:quickseen_agent/service/auth.dart';
import 'package:quickseen_agent/shared/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: QuickAuthService().user,
      child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'QuickSeen Agent',
          theme: ThemeData(
            primaryColor: colorPrimaryRed,
            accentColor: colorWhite,
          ),
          home: AnimatedSplashScreen(
            duration: (3000),
            splash: Image.asset("assets/images/full_logo.png"),
            nextScreen: Wrapper(),
            backgroundColor: colorWhite,
          )),
    );
  }
}

