import 'package:flutter/material.dart';

// Tema em um único lugar = consistência visual garantida.
// Mudar a cor primária do app inteiro = alterar UMA linha aqui.

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF1A1A2E);    // azul escuro quase preto
  static const Color secondary = Color(0xFFE94560);  // vermelho cinema
  static const Color surface = Color(0xFF16213E);
  static const Color cardBg = Color(0xFF0F3460);
  static const Color textLight = Color(0xFFF5F5F5);
  static const Color textMuted = Color(0xFFB0B0C0);
  static const Color gold = Color(0xFFFFD700);       // cor de estrela/rating

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: primary,
        colorScheme: const ColorScheme.dark(
          primary: secondary,
          secondary: cardBg,
          surface: surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: textLight,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          color: cardBg,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: textMuted),
          prefixIconColor: textMuted,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: textLight,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          titleMedium: TextStyle(
            color: textLight,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          bodyMedium: TextStyle(color: textMuted, fontSize: 13),
        ),
      );
}
