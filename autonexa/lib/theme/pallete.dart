import 'package:flutter/material.dart';

class Pallete {
  // AutoNexa Premium Theme Colors (Based on AI Market UI)
  static const Color primaryColor = Color(
    0xFF1E1E1E,
  ); // Dark Grey/Black for main actions
  static const Color secondaryColor = Color(0xFFFF5236); // Vibrant Coral/Red
  static const Color accentColor = Color(0xFFFF5236);

  static const Color backgroundColor = Color(
    0xFFF7F7F7,
  ); // Very light greyish white
  static const Color surfaceColor = Color(0xFFFFFFFF); // Pure white cards
  static const Color textColor = Color(0xFF1E1E1E); // Dark text
  static const Color textSecondaryColor = Color(0xFF8A8A8E); // Soft grey text

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: backgroundColor,
    cardColor: surfaceColor,
    primaryColor: primaryColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: textColor),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ), // Pill shaped
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0x0A000000), // Very light grey fill
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100), // Pill search bars
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: const TextStyle(color: textSecondaryColor),
      hintStyle: const TextStyle(color: textSecondaryColor),
    ),
  );

  static var darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E1E),
    primaryColor: const Color(0xFFFFFFFF),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0x1FFFFFFF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.grey),
      hintStyle: const TextStyle(color: Colors.grey),
    ),
  );
}
