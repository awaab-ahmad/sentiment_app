import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: const Color(0x00000000),
      systemNavigationBarColor: const Color(0xFFFBF6EF),
      statusBarIconBrightness: .dark,
      systemNavigationBarIconBrightness: .dark,
    ),
  ),
  scaffoldBackgroundColor: const Color(0xFFFBF6EF),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFFFFFFF),
    primary: const Color(0xFFE8674A),
    onPrimary: const Color(0xFFFFE1B7),
    onPrimaryContainer: const Color(0xFFFFFFFF),
    onPrimaryFixed: const Color(0xFFEAE3D6),
    secondary: const Color(0xFF2E2A25),
    onSecondary: const Color(0xFFF2EEE6),
    // all 3 surface are related to texts
    surface: const Color(0xFF2E2A25),
    onSurface: const Color(0xFF8A8479),
    surfaceDim: const Color(0xFFFBF6EF),
    // error, onError, onErrorContainer - for background of mood icons
    error: const Color(0xFFEAF3E4),
    onError: const Color(0xFFF7DADA),
    onErrorContainer: const Color(0xFFF4EEDD),
    // all 3 tertiary types are colors of mood icons
    tertiary: const Color(0xFF5C8A5C),
    onTertiary: const Color(0xFFC05B4C),
    onTertiaryContainer: const Color(0xFFB8973F),
  ),
  textTheme: const TextTheme(
    displaySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 15,
      fontWeight: .w800,
      color: Color(0xFF2E2A25),
    ),
    displayMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 15,
      fontWeight: .w800,
      color: Color(0xFF2E2A25),
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
      fontWeight: .w600,
      color: Color(0xFF2E2A25),
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18,
      fontWeight: .w600,
      color: Color(0xFF2E2A25),
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: .w600,
      color: Color(0xFF8A8479),
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: .w600,
      color: Color(0xFF2E2A25),
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: .w600,
      color: Color(0xFF8A8479),
    ),
    bodySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: .w400,
      color: Color(0xFF2E2A25),
    ),
    labelSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: .w500,
      color: Color(0xFFFBF6EF),
    ),
    
  ),
);
