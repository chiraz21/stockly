import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'theme.dart';

void main() {
  runApp(const StocklyApp());
}

class StocklyApp extends StatelessWidget {
  const StocklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stockly',
      theme: appTheme,
      home: const WelcomeScreen(),
    );
  }
}
