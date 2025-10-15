import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard_screen.dart';
import 'providers/file_manager_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FileManagerProvider())],
      child: MaterialApp(
        title: 'Prikriti File Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1A73E8), // Google Blue
            brightness: Brightness.light,
            primary: const Color(0xFF1A73E8),
            secondary: const Color(0xFF34A853), // Google Green
            tertiary: const Color(0xFFFBBC04), // Google Yellow
            error: const Color(0xFFEA4335), // Google Red
          ),
          scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          useMaterial3: true,

          // Modern Typography
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Color(0xFF202124),
            ),
            displayMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Color(0xFF202124),
            ),
            titleLarge: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
              color: Color(0xFF202124),
            ),
            titleMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.15,
              color: Color(0xFF202124),
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.15,
              color: Color(0xFF5F6368),
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.25,
              color: Color(0xFF5F6368),
            ),
            labelLarge: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
              color: Color(0xFF1A73E8),
            ),
          ),

          // Card Theme
          cardTheme: const CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              side: BorderSide(color: Color(0xFFE8EAED), width: 1),
            ),
            color: Colors.white,
          ),

          // Elevated Button Theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.25,
              ),
            ),
          ),

          // Icon Theme
          iconTheme: const IconThemeData(color: Color(0xFF5F6368), size: 20),
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}
