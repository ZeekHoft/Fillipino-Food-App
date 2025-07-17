import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light = ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      textTheme:
          GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge:
            GoogleFonts.itim(fontSize: 48, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.normal,
          color: lightColorScheme.primary,
        ),
        headlineMedium: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        labelLarge: TextStyle(color: lightColorScheme.primary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: lightColorScheme.onPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          backgroundColor: lightColorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFFFCFFF9),
      navigationBarTheme: NavigationBarThemeData(
          indicatorColor: lightColorScheme.primaryContainer,
          iconTheme: WidgetStateProperty.all(
              IconThemeData(color: lightColorScheme.primary))));

  static ThemeData dark = ThemeData(
    colorScheme: darkColorScheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: darkColorScheme.onPrimaryContainer,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: darkColorScheme.primaryContainer,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    ),
    textTheme:
        GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.itim(fontSize: 48, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.normal,
        color: darkColorScheme.primary,
      ),
      headlineMedium: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      labelLarge: TextStyle(color: darkColorScheme.primary),
    ),
  );
}

/// Light [ColorScheme] made with FlexColorScheme v8.2.0.
/// Requires Flutter 3.22.0 or later.
const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF3A7F00),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFA9F775),
  onPrimaryContainer: Color(0xFF0A2100),
  primaryFixed: Color(0xFFA9F775),
  primaryFixedDim: Color(0xFF8EDA5C),
  onPrimaryFixed: Color(0xFF0A2100),
  onPrimaryFixedVariant: Color(0xFF235100),
  secondary: Color(0xFF50653D),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE0F9C6),
  onSecondaryContainer: Color(0xFF0E2002),
  secondaryFixed: Color(0xFFD2EBB8),
  secondaryFixedDim: Color(0xFFB6CE9E),
  onSecondaryFixed: Color(0xFF0E2002),
  onSecondaryFixedVariant: Color(0xFF394C27),
  tertiary: Color(0xFF314E19),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFADD18D),
  onTertiaryContainer: Color(0xFF0C2000),
  tertiaryFixed: Color(0xFFC9EEA7),
  tertiaryFixedDim: Color(0xFFADD18D),
  onTertiaryFixed: Color(0xFF0C2000),
  onTertiaryFixedVariant: Color(0xFF314E19),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  surface: Color(0xFFEDF9DA),
  onSurface: Color(0xFF1A1D16),
  surfaceDim: Color(0xFFD1DFBF),
  surfaceBright: Color(0xFFEDF9DA),
  surfaceContainerLowest: Color(0xFFF2FEE8),
  surfaceContainerLow: Color(0xFFE7F5D6),
  surfaceContainer: Color(0xFFE2F0D1),
  surfaceContainerHigh: Color(0xFFDDEBCC),
  surfaceContainerHighest: Color(0xFFD9E6C7),
  onSurfaceVariant: Color(0xFF44483E),
  outline: Color(0xFF74796D),
  outlineVariant: Color(0xFFC4C8BA),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF363F2D),
  onInverseSurface: Color(0xFFF0F2E7),
  inversePrimary: Color(0xFF8EDA5C),
  surfaceTint: Color(0xFFA1F55B),
);

/// Dark [ColorScheme] made with FlexColorScheme v8.2.0.
/// Requires Flutter 3.22.0 or later.
const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF8EDA5C),
  onPrimary: Color(0xFF163800),
  primaryContainer: Color(0xFF235100),
  onPrimaryContainer: Color(0xFFA9F775),
  primaryFixed: Color(0xFFA9F775),
  primaryFixedDim: Color(0xFF8EDA5C),
  onPrimaryFixed: Color(0xFF0A2100),
  onPrimaryFixedVariant: Color(0xFF235100),
  secondary: Color(0xFFB6CE9E),
  onSecondary: Color(0xFF233513),
  secondaryContainer: Color(0xFF394C27),
  onSecondaryContainer: Color(0xFFD2EBB8),
  secondaryFixed: Color(0xFFD2EBB8),
  secondaryFixedDim: Color(0xFFB6CE9E),
  onSecondaryFixed: Color(0xFF0E2002),
  onSecondaryFixedVariant: Color(0xFF394C27),
  tertiary: Color(0xFFC9EEA7),
  onTertiary: Color(0xFF1B3704),
  tertiaryContainer: Color(0xFF48672F),
  onTertiaryContainer: Color(0xFFD7FCB4),
  tertiaryFixed: Color(0xFFC9EEA7),
  tertiaryFixedDim: Color(0xFFADD18D),
  onTertiaryFixed: Color(0xFF0C2000),
  onTertiaryFixedVariant: Color(0xFF314E19),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),
  surface: Color(0xFF151A10),
  onSurface: Color(0xFFE1E4D9),
  surfaceDim: Color(0xFF151A10),
  surfaceBright: Color(0xFF3A3F34),
  surfaceContainerLowest: Color(0xFF10150C),
  surfaceContainerLow: Color(0xFF1D2318),
  surfaceContainer: Color(0xFF21271C),
  surfaceContainerHigh: Color(0xFF2B3026),
  surfaceContainerHighest: Color(0xFF363B30),
  onSurfaceVariant: Color(0xFFC4C8BB),
  outline: Color(0xFF8E9286),
  outlineVariant: Color(0xFF43483E),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFE0E4D7),
  onInverseSurface: Color(0xFF2E312A),
  inversePrimary: Color(0xFF306C00),
  surfaceTint: Color(0xFF8EDA5C),
);
