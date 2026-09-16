import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF00D9FF); // Cyan
  static const Color secondaryColor = Color(0xFFBD00FF); // Purple
  static const Color tertiaryColor = Color(0xFFFF8C00); // Orange
  static const Color backgroundColor = Color(0xFF0A0E27); // Dark Blue
  static const Color surfaceColor = Color(0xFF1a1f3a); // Darker Blue
  static const Color errorColor = Color(0xFFFF4757); // Red
  static const Color successColor = Color(0xFF2ED573); // Green
  static const Color textPrimaryColor = Color(0xFFFFFFFF); // White
  static const Color textSecondaryColor = Color(0xFFB0B0B0); // Light Gray
  static const Color borderColor = Color(0xFF3a4566); // Border Gray

  // Text Styles
  static TextStyle headingLarge = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static TextStyle headingMedium = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static TextStyle headingSmall = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimaryColor,
  );

  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondaryColor,
  );

  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondaryColor,
  );

  static TextStyle buttonText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: backgroundColor,
  );

  // Theme Data
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: surfaceColor,
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: headingSmall,
      iconTheme: IconThemeData(color: primaryColor),
    ),
    textTheme: TextTheme(
      displayLarge: headingLarge,
      displayMedium: headingMedium,
      displaySmall: headingSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      hintStyle: bodyMedium,
      labelStyle: bodyMedium,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: errorColor),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: buttonText,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: BorderSide(color: primaryColor),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    ),
  );

  // Gradient Colors
  static LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryColor, tertiaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient tertiaryGradient = LinearGradient(
    colors: [tertiaryColor, primaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Border Radius
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;

  // Spacing
  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 16;
  static const double spacingL = 24;
  static const double spacingXL = 32;
}