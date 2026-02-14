
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentation/providers/theme/theme_provider.dart';

class AppTheme {
  AppTheme._();

  // Psychological Palette
  static const Color _sageGreen = Color(0xFF8FA395);
  static const Color _lavender = Color(0xFFDCD6F7); // Slightly more saturated for visibility
  static const Color _warmGrey = Color(0xFFF5F5F0); // Warm White/Grey
  static const Color _deepCharcoal = Color(0xFF2D2D2D);

  static TextTheme _buildTextTheme(TextTheme base) {
    return GoogleFonts.poppinsTextTheme(base);
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _sageGreen, 
        brightness: Brightness.light
      ),
      textTheme: _buildTextTheme(ThemeData.light().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: ColorScheme.fromSeed(
        seedColor: _sageGreen, 
        brightness: Brightness.dark
      ),
      textTheme: _buildTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        centerTitle: true,
        elevation: 0,
      ),
    );
  }

  // The "Aurora" Theme (Calming)
  static ThemeData get calmingTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: _warmGrey,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: _sageGreen,
        onPrimary: Colors.white,
        secondary: _lavender,
        onSecondary: _deepCharcoal,
        error: Colors.redAccent,
        onError: Colors.white,
        surface: _warmGrey, 
        onSurface: _deepCharcoal,
      ),
      textTheme: _buildTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: _deepCharcoal,
        displayColor: _deepCharcoal,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent, // Transparent for glass effect
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: _deepCharcoal),
        titleTextStyle: TextStyle(
          color: _deepCharcoal, 
          fontSize: 20, 
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
      ),
    );
  }
  // --- Premium Themes ---

  // 1. Cyberpunk (Neon & High Contrast)
  static ThemeData get cyberpunkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0D0221), // Deep purple/black
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00F0FF), // Neon Cyan
        onPrimary: Colors.black,
        secondary: Color(0xFFFF0099), // Neon Pink
        onSecondary: Colors.white,
        surface: Color(0xFF190436),
        onSurface: Color(0xFFE0E0E0),
        error: Color(0xFFFF2A6D),
      ),
      textTheme: GoogleFonts.orbitronTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: const Color(0xFFE0E0E0),
        displayColor: const Color(0xFF00F0FF),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF00F0FF)),
    );
  }

  // 2. RGB (Gamer/Colorful)
  static ThemeData get rgbTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF000000),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFF0000), // Red
        secondary: Color(0xFF00FF00), // Green (Accent)
        tertiary: Color(0xFF0000FF), // Blue
        surface: Color(0xFF111111),
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.pressStart2pTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: Colors.white,
      ),
    );
  }

  // 3. Vintage (Sepia/Retro)
  static ThemeData get vintageTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF4E4BC), // Sepia paper
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF8B4513), // Saddle Brown
        onPrimary: Colors.white,
        secondary: Color(0xFFCD853F), // Peru
        surface: Color(0xFFE6D6AD),
        onSurface: Color(0xFF5D4037),
      ),
      textTheme: GoogleFonts.merriweatherTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: const Color(0xFF5D4037),
        displayColor: const Color(0xFF3E2723),
      ),
    );
  }

  // 4. Ocean (Blue/Teal/Calm)
  static ThemeData get oceanTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFE0F7FA), // Light Cyan
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF006064), // Cyan 900
        onPrimary: Colors.white,
        secondary: Color(0xFF00ACC1), // Cyan 600
        surface: Color(0xFFB2EBF2),
        onSurface: Color(0xFF004D40),
      ),
      textTheme: GoogleFonts.montserratTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: const Color(0xFF004D40),
      ),
    );
  }

  // 5. Flower (Pink/Pastel/Soft)
  static ThemeData get flowerTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFFFF0F5), // Lavender Blush
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFDB7093), // Pale Violet Red
        onPrimary: Colors.white,
        secondary: Color(0xFFFFB6C1), // Light Pink
        surface: Color(0xFFFFE4E1), // Misty Rose
        onSurface: Color(0xFF880E4F),
      ),
      textTheme: GoogleFonts.playfairDisplayTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: const Color(0xFF880E4F),
      ),
    );
  }

  // 6. Electro (Tech/Security/Green Matrix)
  static ThemeData get electroTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF051105), // Dark Green Black
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00FF41), // Matrix Green
        onPrimary: Colors.black,
        secondary: Color(0xFF008F11),
        surface: Color(0xFF0A1F0A),
        onSurface: Color(0xFF00FF41),
      ),
      textTheme: GoogleFonts.vt323TextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: const Color(0xFF00FF41),
        displayColor: const Color(0xFF00FF41),
      ),
      dividerColor: const Color(0xFF00FF41),
    );
  }

  // --- Theme Helpers ---

  static ThemeData getThemeData(AppThemeMode mode) => switch (mode) {
    AppThemeMode.light => lightTheme,
    AppThemeMode.dark => darkTheme,
    AppThemeMode.calming => calmingTheme,
    AppThemeMode.cyberpunk => cyberpunkTheme,
    AppThemeMode.rgb => rgbTheme,
    AppThemeMode.vintage => vintageTheme,
    AppThemeMode.ocean => oceanTheme,
    AppThemeMode.flower => flowerTheme,
    AppThemeMode.electro => electroTheme,
  };

  static ThemeMode getThemeMode(AppThemeMode mode) => switch (mode) {
    AppThemeMode.light ||
    AppThemeMode.calming ||
    AppThemeMode.vintage ||
    AppThemeMode.ocean ||
    AppThemeMode.flower => ThemeMode.light,
    AppThemeMode.dark ||
    AppThemeMode.cyberpunk ||
    AppThemeMode.rgb ||
    AppThemeMode.electro => ThemeMode.dark,
  };
}
