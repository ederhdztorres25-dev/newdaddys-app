import 'package:flutter/material.dart';

class AppFonts {
  AppFonts._(); // Clase estática (no instanciable)

  // ───────────────────────────────────────────────
  // 1. TÍTULOS
  // ───────────────────────────────────────────────
  static const TextStyle h1 = TextStyle(
    fontFamily: 'MonaSans',
    fontSize: 32,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: 'MonaSans',
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: 'MonaSans',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: 'MonaSans',
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  // ───────────────────────────────────────────────
  // 2. TEXTO DE CUERPO
  // ───────────────────────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'MonaSans',
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'MonaSans',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'MonaSans',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}
