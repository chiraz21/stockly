import 'package:flutter/material.dart';

const Color primaryGreen = Color(0xFF63C28D);
const Color lightGreen = Color(0xFFE6F6EC);

ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: primaryGreen,
  fontFamily: 'Poppins',
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      minimumSize: const Size(double.infinity, 55),
    ),
  ),
);
