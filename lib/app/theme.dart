import 'package:flutter/material.dart';

/// Design tokens from the Stitch design system "NostalPlay Monolith LCD".
class NpColors {
  const NpColors._();

  // LCD matrix
  static const lcdBright = Color(0xFF9BBC0F);
  static const lcdMid = Color(0xFF8BAC0F);
  static const lcdDark = Color(0xFF306230);
  static const lcdDeep = Color(0xFF0F380F);

  // Hardware shell
  static const chassisIvory = Color(0xFFC9C6BA);
  static const chassisBevel = Color(0xFF8E8B80);
  static const controlCharcoal = Color(0xFF2B2B2B);
  static const actionCrimson = Color(0xFF9B2335);
  static const silkscreen = Color(0xFF4A4A4A);

  // App shell
  static const ground = Color(0xFF1E2420);
  static const card = Color(0xFF2B332D);
  static const border = Color(0xFF3D483F);
  static const surface = Color(0xFF0F1511);
  static const primary = Color(0xFFB1D43D);
  static const onPrimary = Color(0xFF293500);
  static const onSurface = Color(0xFFDEE4DD);
  static const onSurfaceVariant = Color(0xFFC5C9B1);
}

const String kMono = 'Space Mono';
const String kSans = 'Inter';

ThemeData buildTheme() {
  const scheme = ColorScheme.dark(
    surface: NpColors.surface,
    primary: NpColors.primary,
    onPrimary: NpColors.onPrimary,
    onSurface: NpColors.onSurface,
    secondary: NpColors.actionCrimson,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: NpColors.ground,
    fontFamily: kSans,
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontFamily: kMono,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        letterSpacing: -0.96,
        color: NpColors.primary,
      ),
      labelLarge: TextStyle(
        fontFamily: kMono,
        fontWeight: FontWeight.w700,
        fontSize: 11,
        letterSpacing: 1.3,
        color: NpColors.onSurfaceVariant,
      ),
      bodyMedium: TextStyle(
        fontFamily: kSans,
        fontSize: 14,
        color: NpColors.lcdMid,
      ),
    ),
  );
}

/// Text style for everything drawn on the LCD (Space Mono supports Vietnamese).
TextStyle lcdStyle({
  double size = 13,
  Color color = NpColors.lcdDeep,
  FontWeight weight = FontWeight.w700,
  double letterSpacing = 0.8,
}) {
  return TextStyle(
    fontFamily: kMono,
    fontWeight: weight,
    fontSize: size,
    letterSpacing: letterSpacing,
    color: color,
    height: 1.2,
  );
}
