import 'package:flutter/material.dart';

// --- Colors for Light Theme ---
class AppColors {
  static const primary = Color(0xFF1F8A70);   // Teal
  static const secondary = Color(0xFFC9A44C); // Soft Gold
  static const background = Color(0xFFF7F9F8); // Very light grey
  static const card = Colors.white; // Card background
  static const textDark = Color(0xFF1C1C1C);
  static const textLight = Color(0xFF6B6B6B);
}

// ✨ NEW: Colors for Dark Theme ---
class AppColorsDark {
  static const primary = Color(0xFF26A69A);   // A slightly brighter Teal for dark mode
  static const secondary = Color(0xFFD4B46A); // A slightly brighter Gold
  static const background = Color(0xFF121212); // Standard dark background
  static const card = Color(0xFF1E1E1E);       // Dark card color
  static const textDark = Color(0xFFE0E0E0);   // Light grey text
  static const textLight = Color(0xFF9E9E9E);  // Dimmer grey text
}

class AppTheme {
  // --- Light Theme Definition ---
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: AppColors.background,
        surface: AppColors.card, // For cards
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onBackground: AppColors.textDark,
        onSurface: AppColors.textDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textDark),
        bodyMedium: TextStyle(color: AppColors.textLight),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ✨ NEW: Dark Theme Definition ---
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColorsDark.background,
      primaryColor: AppColorsDark.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColorsDark.primary,
        secondary: AppColorsDark.secondary,
        background: AppColorsDark.background,
        surface: AppColorsDark.card, // For cards
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onBackground: AppColorsDark.textDark,
        onSurface: AppColorsDark.textDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsDark.card, // Darker App Bar
        foregroundColor: AppColorsDark.textDark,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColorsDark.primary,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColorsDark.textDark),
        bodyMedium: TextStyle(color: AppColorsDark.textLight),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorsDark.card,
        hintStyle: const TextStyle(color: AppColorsDark.textLight),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColorsDark.primary, width: 2),
        ),
      ),
      // ... inside darkTheme getter
      cardTheme: CardThemeData( // ✨ CORRECTED: Use CardThemeData instead of CardTheme
        color: AppColorsDark.card,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Optional: consistent styling
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade800,
      ),
    );
  }
}
