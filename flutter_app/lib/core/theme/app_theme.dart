import 'package:flutter/material.dart';

class AppColors {
  // 1989 Era - Light Mode
  static const light1989Primary = Color(0xFF7DA9D8);
  static const light1989Secondary = Color(0xFFBFD9F2);
  static const light1989Background = Color(0xFFF8FAFD);
  static const light1989Card = Color(0xFFFFFFFF);
  static const light1989Accent = Color(0xFF5B8BCB);
  static const light1989Text = Color(0xFF1F2937);
  static const light1989TextSecondary = Color(0xFF6B7280);
  static const light1989TextTertiary = Color(0xFF9CA3AF);
  static const light1989Border = Color(0xFFE5EDF5);

  // Reputation Era - Dark Mode
  static const darkRepPrimary = Color(0xFF111111);
  static const darkRepSecondary = Color(0xFF1C1C1E);
  static const darkRepCard = Color(0xFF1A1A1A);
  static const darkRepGold = Color(0xFFD4AF37);
  static const darkRepText = Color(0xFFF5F5F5);
  static const darkRepTextSecondary = Color(0xFF9999AA);
  static const darkRepTextTertiary = Color(0xFF555566);
  static const darkRepBorder = Color(0xFF2A2A2A);
  static const darkRepSuccess = Color(0xFF4ADE80);
  static const darkRepError = Color(0xFFFF4757);

  // Shared
  static const primary = Color(0xFF7DA9D8);
  static const gold = Color(0xFFD4AF37);
  static const success = Color(0xFF4ADE80);
  static const error = Color(0xFFFF4757);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.light1989Background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.light1989Primary,
        secondary: AppColors.light1989Accent,
        surface: AppColors.light1989Card,
        error: AppColors.darkRepError,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.light1989Background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.light1989Text,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.light1989Text),
      ),
      cardTheme: CardThemeData(
        color: AppColors.light1989Card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.light1989Border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.light1989Primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.3),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.light1989Card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.light1989Border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.light1989Border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.light1989Primary, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.light1989TextSecondary),
        hintStyle: const TextStyle(color: AppColors.light1989TextTertiary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.light1989Text, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1),
        displayMedium: TextStyle(color: AppColors.light1989Text, fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        titleLarge: TextStyle(color: AppColors.light1989Text, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.3),
        titleMedium: TextStyle(color: AppColors.light1989Text, fontSize: 16, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: AppColors.light1989Text, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.light1989TextSecondary, fontSize: 14),
        bodySmall: TextStyle(color: AppColors.light1989TextTertiary, fontSize: 12),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkRepPrimary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkRepGold,
        secondary: AppColors.darkRepSuccess,
        surface: AppColors.darkRepSecondary,
        error: AppColors.darkRepError,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkRepPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.darkRepText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.darkRepText),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkRepCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkRepBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkRepGold,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.3),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkRepCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkRepBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkRepBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkRepGold, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.darkRepTextSecondary),
        hintStyle: const TextStyle(color: AppColors.darkRepTextTertiary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.darkRepText, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1),
        displayMedium: TextStyle(color: AppColors.darkRepText, fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        titleLarge: TextStyle(color: AppColors.darkRepText, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.3),
        titleMedium: TextStyle(color: AppColors.darkRepText, fontSize: 16, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: AppColors.darkRepText, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.darkRepTextSecondary, fontSize: 14),
        bodySmall: TextStyle(color: AppColors.darkRepTextTertiary, fontSize: 12),
      ),
    );
  }
}
