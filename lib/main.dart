import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    // for whole app usenig provider
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const EarthRhythmApp(),
    ),
  );
}

class EarthRhythmApp extends StatelessWidget {
  const EarthRhythmApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Earth Rhythm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2E5C41), // green theam
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF2E5C41),
          secondary: const Color(0xFFD4B79A), //natural earth color
        ),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(), // 1st splash screen
    );
  }
}
