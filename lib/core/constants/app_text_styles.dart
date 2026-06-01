// ─────────────────────────────────────────────────────────────────────────────
// App Text Styles — Service Sphere
// Uses Google Fonts: Poppins (headings) + Inter (body)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Display / Hero ─────────────────────────────────────────────────────────
  static TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.1,
  );
  static TextStyle displayMedium = GoogleFonts.poppins(
    fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.2,
  );
  static TextStyle displaySmall = GoogleFonts.poppins(
    fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3,
  );

  // ── Headings ──────────────────────────────────────────────────────────────
  static TextStyle h1 = GoogleFonts.poppins(
    fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );
  static TextStyle h2 = GoogleFonts.poppins(
    fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );
  static TextStyle h3 = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );
  static TextStyle h4 = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  // ── Body ──────────────────────────────────────────────────────────────────
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
  );
  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
  );
  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
  );

  // ── Labels & Captions ─────────────────────────────────────────────────────
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );
  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );
  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted,
    letterSpacing: 0.8, 
  );
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textMuted,
  );

  // ── Button ────────────────────────────────────────────────────────────────
  static TextStyle button = GoogleFonts.poppins(
    fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );
  static TextStyle buttonSmall = GoogleFonts.poppins(
    fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  // ── Special ───────────────────────────────────────────────────────────────
  static TextStyle logo = GoogleFonts.poppins(
    fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  static TextStyle price = GoogleFonts.poppins(
    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.accent,
  );
  static TextStyle priceSmall = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.accent,
  );
  static TextStyle overline = GoogleFonts.inter(
    fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted,
    letterSpacing: 1.5,
  );
}
