import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Palette dari referensi gambar
  static const Color cafeNoir     = Color(0xFF4C3D19); // coklat gelap
  static const Color kombuGreen   = Color(0xFF354024); // hijau gelap
  static const Color mossGreen    = Color(0xFF889063); // hijau medium
  static const Color tan          = Color(0xFFCFBB99); // krem kecoklatan
  static const Color bone         = Color(0xFFE5D7C4); // krem terang
  static const Color primary      = kombuGreen;
  static const Color primaryLight = mossGreen;
  static const Color secondary    = cafeNoir;
  static const Color background   = Color(0xFF1C2412); // lebih gelap dari kombu
  static const Color surface      = Color(0xFF253018); // sedikit lebih terang
  static const Color surfaceCard  = Color(0xFF2E3D1F); // kartu
  static const Color textPrimary  = bone;
  static const Color textSecondary= tan;
  static const Color textMuted    = mossGreen;
  static const Color accent       = Color(0xFFD4A843); // gold accent
  static const Color error        = Color(0xFFE05555);
  static const Color success      = Color(0xFF6AAB3C);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: primary,
        onPrimary: bone,
        secondary: accent,
        onSecondary: cafeNoir,
        error: error,
        onError: Colors.white,
        surface: surface,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mossGreen,
          foregroundColor: bone,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: mossGreen, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: mossGreen.withOpacity(0.4), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: tan, width: 1.5),
        ),
        hintStyle: GoogleFonts.poppins(color: textMuted, fontSize: 14),
        prefixIconColor: mossGreen,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: accent,
        unselectedItemColor: mossGreen,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
