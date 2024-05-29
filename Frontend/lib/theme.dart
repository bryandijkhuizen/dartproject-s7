import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ColorScheme darkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFFCD0612),
)
    // Overwrite the seeded colors with copyWith
    .copyWith(
  primary: const Color(0xFFCD0612),
  brightness: Brightness.dark,
  secondary: const Color(0xFF2C4789),
  surface: const Color(0xFF101010),
  onSurface: Colors.white,
);

ThemeData darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor:
        darkColorScheme.primary, // Ensures AppBar uses the exact red color
    foregroundColor: Colors.white, // Ensures text and icons are white
  ),
  brightness: Brightness.dark,
  cardTheme: const CardTheme(
    color: Color(0xFF444444),
    margin: EdgeInsets.all(0.0),
  ),
  colorScheme: darkColorScheme,
  dropdownMenuTheme: DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor: WidgetStatePropertyAll(darkColorScheme.surface),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
        darkColorScheme.primary,
      ),
      foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      shape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.never,
    labelStyle: const TextStyle(
      color: Color(0xFF6F6F6F),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    iconColor: darkColorScheme.onSurface,
    prefixIconColor: darkColorScheme.onSurface,
    suffixIconColor: darkColorScheme.onSurface,
    filled: true,
    fillColor: darkColorScheme.surface,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: darkColorScheme.primary,
    height: 56,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
    indicatorColor: darkColorScheme.surface,
    iconTheme:
        WidgetStateProperty.resolveWith(getNavigationIconThemeMaterialState),
  ),
  scaffoldBackgroundColor: darkColorScheme.surface,
  textTheme: TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 94,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 59,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 47,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 33,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.15,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.15,
    ),
    titleSmall: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.1,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    labelLarge: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(darkColorScheme.onPrimary),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      ),
    ),
  ),
  useMaterial3: true,
);

ThemeData lightTheme = ThemeData();

IconThemeData? getNavigationIconThemeMaterialState(Set<WidgetState> states) {
  // Return fallback with custom color no matter what states are active for now
  return const IconThemeData.fallback()
      .copyWith(color: darkColorScheme.onPrimary);
}
