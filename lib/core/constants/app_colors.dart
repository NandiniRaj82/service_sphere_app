// ─────────────────────────────────────────────────────────────────────────────
// App Color Palette — Service Sphere
// Primary: Deep Violet | Accent: Coral | Dark-first design system
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color primary        = Color(0xFF5B21B6); // Deep Violet
  static const Color primaryLight   = Color(0xFF7C3AED);
  static const Color primaryDark    = Color(0xFF3B0764);
  static const Color accent         = Color(0xFFFF6B6B); // Coral
  static const Color accentLight    = Color(0xFFFF8E8E);
  static const Color accentDark     = Color(0xFFE63E3E);

  // ── Gradients ──────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5B21B6), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0F0F1A), Color(0xFF1A1A2E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E1E3A), Color(0xFF16213E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Dark Theme Surfaces ────────────────────────────────────────────────────
  static const Color backgroundDark  = Color(0xFF0F0F1A);
  static const Color surfaceDark     = Color(0xFF1A1A2E);
  static const Color cardDark        = Color(0xFF16213E);
  static const Color borderDark      = Color(0xFF2D2D4E);
  static const Color dividerDark     = Color(0xFF1E1E3A);

  // ── Light Theme Surfaces ───────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF8F7FF);
  static const Color surfaceLight    = Color(0xFFFFFFFF);
  static const Color cardLight       = Color(0xFFF1EEF8);
  static const Color borderLight     = Color(0xFFE2D9F3);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary     = Color(0xFFFFFFFF);
  static const Color textSecondary   = Color(0xFF94A3B8);
  static const Color textMuted       = Color(0xFF64748B);
  static const Color textDark        = Color(0xFF1E1B4B);

  // ── Status ────────────────────────────────────────────────────────────────
  static const Color success         = Color(0xFF10B981);
  static const Color successLight    = Color(0xFFD1FAE5);
  static const Color warning         = Color(0xFFF59E0B);
  static const Color warningLight    = Color(0xFFFEF3C7);
  static const Color error           = Color(0xFFEF4444);
  static const Color errorLight      = Color(0xFFFEE2E2);
  static const Color info            = Color(0xFF3B82F6);
  static const Color infoLight       = Color(0xFFDBEAFE);

  // ── Booking Status Colors ──────────────────────────────────────────────────
  static const Color statusPending   = Color(0xFFF59E0B);
  static const Color statusConfirmed = Color(0xFF10B981);
  static const Color statusRejected  = Color(0xFFEF4444);
  static const Color statusCompleted = Color(0xFF6366F1);
  static const Color statusCancelled = Color(0xFF94A3B8);

  // ── Glass effect ──────────────────────────────────────────────────────────
  static Color glassWhite   = Colors.white.withOpacity(0.08);
  static Color glassBorder  = Colors.white.withOpacity(0.15);
  static Color glassOverlay = Colors.white.withOpacity(0.05);

  // ── Category Colors ───────────────────────────────────────────────────────
  static const List<Color> categoryColors = [
    Color(0xFF5B21B6), Color(0xFFFF6B6B), Color(0xFF10B981),
    Color(0xFFF59E0B), Color(0xFF3B82F6), Color(0xFFEC4899),
    Color(0xFF14B8A6), Color(0xFF8B5CF6),
  ];
}
