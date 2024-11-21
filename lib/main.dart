import 'package:flutter/material.dart';
import 'package:world_time_app/screens/choose_location.dart';
import 'package:world_time_app/screens/home.dart';
import 'screens/splash_screen.dart';



void main() => runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => SplashScreen(),
      '/home': (context) => Home(),
      '/location': (context) => ChooseLocation(),
    },
    debugShowCheckedModeBanner: false, 
));
