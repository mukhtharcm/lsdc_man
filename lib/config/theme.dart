import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Custom colors
  static const customSchemeColor = FlexSchemeColor(
    primary: Color(0xFF2E7D32), // Deep green
    primaryContainer: Color(0xFFB9F6CA), // Light mint
    secondary: Color(0xFF00796B), // Teal
    secondaryContainer: Color(0xFFB2DFDB), // Light teal
    tertiary: Color(0xFFFFA000), // Amber
    tertiaryContainer: Color(0xFFFFECB3), // Light amber
  );

  static ThemeData get lightTheme {
    final poppinsTextTheme = GoogleFonts.poppinsTextTheme();
    return FlexThemeData.light(
      colors: customSchemeColor,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 7,
      subThemesData: FlexSubThemesData(
        blendOnLevel: 10,
        blendOnColors: false,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
        alignedDropdown: true,
        useInputDecoratorThemeInDialogs: true,
        fabUseShape: true,
        interactionEffects: true,
        bottomNavigationBarElevation: 0,
        bottomNavigationBarOpacity: 0.95,
        navigationBarOpacity: 0.95,
        navigationBarMutedUnselectedIcon: true,
        inputDecoratorIsFilled: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorUnfocusedHasBorder: true,
        inputDecoratorFocusedHasBorder: true,
        inputDecoratorFillColor: Colors.grey.shade50,
        inputDecoratorRadius: 8,
        inputDecoratorUnfocusedBorderIsColored: false,
        inputDecoratorBorderWidth: 1.0,
        inputDecoratorFocusedBorderWidth: 2.0,
        inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
        popupMenuRadius: 8,
        cardRadius: 12,
        dialogRadius: 12,
        defaultRadius: 8,
        buttonMinSize: const Size(64, 40),
      ),
      keyColors: const FlexKeyColors(
        useSecondary: true,
        useTertiary: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: poppinsTextTheme,
    );
  }

  static ThemeData get darkTheme {
    final poppinsTextTheme = GoogleFonts.poppinsTextTheme();
    return FlexThemeData.dark(
      colors: customSchemeColor,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 13,
      subThemesData: FlexSubThemesData(
        blendOnLevel: 20,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
        alignedDropdown: true,
        useInputDecoratorThemeInDialogs: true,
        fabUseShape: true,
        interactionEffects: true,
        bottomNavigationBarElevation: 0,
        bottomNavigationBarOpacity: 0.95,
        navigationBarOpacity: 0.95,
        navigationBarMutedUnselectedIcon: true,
        inputDecoratorIsFilled: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorUnfocusedHasBorder: true,
        inputDecoratorFocusedHasBorder: true,
        inputDecoratorFillColor: Colors.grey.shade900,
        inputDecoratorRadius: 8,
        inputDecoratorUnfocusedBorderIsColored: false,
        inputDecoratorBorderWidth: 1.0,
        inputDecoratorFocusedBorderWidth: 2.0,
        inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
        popupMenuRadius: 8,
        cardRadius: 12,
        dialogRadius: 12,
        defaultRadius: 8,
        buttonMinSize: const Size(64, 40),
      ),
      keyColors: const FlexKeyColors(
        useSecondary: true,
        useTertiary: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: poppinsTextTheme,
    );
  }

  // Custom spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Custom border radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
}
