import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFCD0612),
  )
      // Overwrite the seeded colors with copyWith
      .copyWith(
    brightness: Brightness.dark,
    secondary: const Color(0xFF2C4789),
    background: const Color(0xFF060606),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF9F9F9),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    iconColor: Colors.black,
    prefixIconColor: Colors.black,
    labelStyle: const TextStyle(
      color: Color(0xFF6B6B6B),
    ),
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.poppins(
        fontSize: 94, fontWeight: FontWeight.w300, letterSpacing: -1.5),
    displayMedium: GoogleFonts.poppins(
        fontSize: 59, fontWeight: FontWeight.w300, letterSpacing: -0.5),
    displaySmall:
        GoogleFonts.poppins(fontSize: 47, fontWeight: FontWeight.w400),
    headlineMedium: GoogleFonts.poppins(
        fontSize: 33, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    headlineSmall:
        GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w400),
    titleLarge: GoogleFonts.poppins(
        fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.15),
    titleMedium: GoogleFonts.poppins(
        fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.15),
    titleSmall: GoogleFonts.poppins(
        fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.1),
    bodyLarge: GoogleFonts.poppins(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
    bodyMedium: GoogleFonts.poppins(
        fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    labelLarge: GoogleFonts.poppins(
        fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
    bodySmall: GoogleFonts.poppins(
        fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
    labelSmall: GoogleFonts.poppins(
        fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
  ),
);

ThemeData lightTheme = ThemeData();