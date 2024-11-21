import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:world_time_app/screens/choose_location.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animation/Animation - 1732021762670.json',
          ),
          const SizedBox(height: 20),
          const Text(
            'World Time App',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
      nextScreen: ChooseLocation(),
      duration: 3000,
      backgroundColor: Colors.white,
      splashIconSize: 2500,
    );
  }
}
