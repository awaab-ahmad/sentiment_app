import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: const Color(0x00000000),
      systemNavigationBarColor: const Color(0xFF1C1A17),
      statusBarIconBrightness: .light,
      systemNavigationBarIconBrightness: .light,
    ),
  ),
  scaffoldBackgroundColor: const Color(0xFF1C1A17),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFFFFFFF),
    primary: const Color(0xFFE8674A),
    onPrimary: const Color(0xFF484848),
    onPrimaryContainer: const Color(0xFF242119),
    onPrimaryFixed: const Color(0xFF332F2A),
    secondary: const Color(0xFFF2EEE6),
    // all 3 surface are related to texts
    surface: const Color(0xFFF2EEE6),
    onSurface: const Color(0xFF8C877D),
    surfaceDim: const Color(0xFF1C1A17),
    // error, onError, onErrorContainer - for background of mood icons
    error: const Color(0xFF213524),
    onError: const Color(0xFF3A2420),
    onErrorContainer: const Color(0xFF332B1B),
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
      color: Color(0xFFF2EEE6),
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
      fontWeight: .w600,
      color: Color(0xFFF2EEE6),
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18,
      fontWeight: .w600,
      color: Color(0xFFF2EEE6),
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: .w600,
      color: Color(0xFF8C877D),
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: .w600,
      color: Color(0xFFF2EEE6),
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: .w600,
      color: Color(0xFF8C877D),
    ),
    bodySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: .w400,
      color: Color(0xFFF2EEE6),
    ),
    labelSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: .w500,
      color: Color(0xFF1C1A17),
    ),
  ),
);
