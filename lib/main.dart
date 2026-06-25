import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
      ],
      child: const EarthRhythmApp(),
    ),
  );
}

class EarthRhythmApp extends StatelessWidget {
  const EarthRhythmApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    
    // Brand design color tokens
    const brandForestGreen = Color(0xFF174A33);
    const brandPeachCoral = Color(0xFFD67A60);
    const lightScaffoldBg = Color(0xFFFAF8F3);
    const darkScaffoldBg = Color(0xFF0E1512);

    return MaterialApp(
      title: 'Earth Rhythm',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandForestGreen,
          primary: brandForestGreen,
          secondary: brandPeachCoral,
          brightness: Brightness.light,
          surface: Colors.white,
          onSurface: const Color(0xFF1A1A1A),
        ),
        scaffoldBackgroundColor: lightScaffoldBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: lightScaffoldBg,
          foregroundColor: Color(0xFF174A33),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF174A33),
            letterSpacing: 0.5,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFEFECE6), width: 1.2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: brandForestGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: brandForestGreen,
            side: const BorderSide(color: brandForestGreen, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        dividerColor: const Color(0xFFEBE6DD),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandForestGreen,
          primary: const Color(0xFF3E8E64), // Slightly lighter green for readability on dark backgrounds
          secondary: brandPeachCoral,
          brightness: Brightness.dark,
          surface: const Color(0xFF16201B),
          onSurface: const Color(0xFFE4F0EA),
        ),
        scaffoldBackgroundColor: darkScaffoldBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: darkScaffoldBg,
          foregroundColor: Color(0xFFE4F0EA),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFFE4F0EA),
            letterSpacing: 0.5,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: const Color(0xFF16201B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF24332B), width: 1.2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3E8E64),
            foregroundColor: Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFE4F0EA),
            side: const BorderSide(color: Color(0xFF2E4036), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        dividerColor: const Color(0xFF24332B),
      ),
      home: const SplashScreen(),
    );
  }
}
