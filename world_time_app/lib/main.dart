import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(WorldTimeApp());
}

class WorldTimeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WorldTime App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Roboto', fontSize: 18.0),
          bodySmall: TextStyle(fontFamily: 'Roboto', fontSize: 14.0, color: Colors.grey[600]),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
