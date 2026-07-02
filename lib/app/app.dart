import 'package:flutter/material.dart';
import '../features/splash/splash_screen.dart';

class StudyFlowApp extends StatelessWidget {
  const StudyFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyFlow',
      home: const SplashScreen(),
    );
  }
}