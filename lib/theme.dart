import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData kaamWaaleTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF4CAF50), // Primary green
    secondary: const Color(0xFFFFC107), // Secondary amber
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Soft neutral background
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontWeight: FontWeight.bold,
      fontSize: 32,
      color: const Color(0xFF333333),
    ),
    headlineMedium: GoogleFonts.poppins(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: const Color(0xFF333333),
    ),
    bodyLarge: GoogleFonts.roboto(
      fontSize: 16,
      height: 1.5,
      color: const Color(0xFF333333),
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 14,
      height: 1.5,
      color: const Color(0xFF333333),
    ),
  ),
  useMaterial3: true,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      shadowColor: Colors.black26,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
);

final ThemeData kaamWaaleDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color(0xFF4CAF50),
    secondary: const Color(0xFFFFC107),
  ),
  scaffoldBackgroundColor: const Color(0xFF0F1115),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontWeight: FontWeight.bold,
      fontSize: 32,
      color: Colors.white,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: Colors.white,
    ),
    bodyLarge: GoogleFonts.roboto(
      fontSize: 16,
      height: 1.5,
      color: Colors.white70,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 14,
      height: 1.5,
      color: Colors.white70,
    ),
  ),
  useMaterial3: true,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      shadowColor: Colors.black54,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1A1D23),
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
);
