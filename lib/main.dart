import 'package:flutter/material.dart';

import 'package:ganesha_app/screen/dashboard_screen.dart';
import 'package:ganesha_app/screen/splash_screen.dart';


void main() {
  runApp(const GaneshaPortalApp());
}

class GaneshaPortalApp extends StatelessWidget {
  const GaneshaPortalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Ganesha Portal',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white, // Premium soft warm background
        primaryColor: const Color(0xFFE65100), // Rich Devotional Orange
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE65100),
          primary: const Color(0xFFE65100),
          secondary: const Color(0xFFFFB300), // Warm Marigold Gold
        ),
      ),
      home: const SplashScreen(),
    );
  }
}