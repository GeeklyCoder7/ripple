import 'package:flutter/material.dart';
import 'package:ripple/screens/home/home_screen.dart';
import 'package:ripple/screens/splash/splash_screen.dart';

import 'core/constants/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShareWave', // Updated title
      debugShowCheckedModeBanner: false,
      theme: AppColors.lightTheme,
      // Preload routes for better performance
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashWavesMoving(),
        '/home': (context) => const HomeScreen(), // Add explicit route
      },
    );
  }
}
