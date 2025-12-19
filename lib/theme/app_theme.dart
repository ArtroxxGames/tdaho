
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/theme/app_colors.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.accentPrimary,
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      dividerColor: Colors.grey[300],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 57, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 45, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 36, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 32, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
        headlineSmall: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w500),
        titleMedium: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14),
        bodySmall: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 12),
        labelLarge: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
        labelMedium: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
        labelSmall: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.accentPrimary,
        secondary: AppColors.accentSecondary,
        surface: Colors.white,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        error: AppColors.accentDanger,
        onError: AppColors.textPrimary,
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.accentPrimary,
      scaffoldBackgroundColor: AppColors.bgPrimary,
      cardColor: AppColors.bgCard,
      dividerColor: AppColors.borderColor,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgSecondary,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 57, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 45, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 36, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 32, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
        headlineSmall: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w500),
        titleMedium: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14),
        bodySmall: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 12),
        labelLarge: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
        labelMedium: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
        labelSmall: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentPrimary,
        secondary: AppColors.accentSecondary,
        surface: AppColors.bgSecondary,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        error: AppColors.accentDanger,
        onError: AppColors.textPrimary,
      ),
    );
  }
}
