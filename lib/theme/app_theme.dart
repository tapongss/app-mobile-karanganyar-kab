import 'package:flutter/material.dart';

/// Palet warna utama aplikasi, mengikuti desain Figma "krakab".
class AppColors {
  static const orange = Color(0xFFFF7733);
  static const orangeDeep = Color(0xFFEF5A16);
  static const orangeSoft = Color(0xFFFFE9DE);
  static const peach = Color(0xFFFFF5EF);
  static const ink = Color(0xFF1E1E24);
  static const inkSoft = Color(0xFF76767F);
  static const line = Color(0xFFECECF1);
  static const bg = Color(0xFFF8F8FB);
  static const green = Color(0xFF2FA36B);
  static const blue = Color(0xFF3D7BF7);
  static const purple = Color(0xFF7A5AF8);
  static const amber = Color(0xFFF5A623);

  static const headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF8A4C), orange, Color(0xFFF4631F)],
  );
}

class AppTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.orange,
      brightness: brightness,
    );

    final cs = base.copyWith(
      primary: AppColors.orange,
      onPrimary: Colors.white,
      primaryContainer: isLight ? AppColors.orangeSoft : const Color(0xFF4A2415),
      onPrimaryContainer: isLight ? AppColors.orangeDeep : const Color(0xFFFFC7AC),
      secondary: AppColors.orangeDeep,
      onSecondary: Colors.white,
      secondaryContainer: isLight ? AppColors.peach : const Color(0xFF3A2116),
      onSecondaryContainer: isLight ? AppColors.ink : const Color(0xFFFFD9C6),
      surface: isLight ? Colors.white : const Color(0xFF1A1A20),
      onSurface: isLight ? AppColors.ink : const Color(0xFFF4F4F7),
      onSurfaceVariant: isLight ? AppColors.inkSoft : const Color(0xFFA5A5B0),
      surfaceContainerHighest:
          isLight ? const Color(0xFFF2F2F6) : const Color(0xFF26262E),
      outline: isLight ? AppColors.line : const Color(0xFF33333D),
      outlineVariant: isLight ? AppColors.line : const Color(0xFF2A2A32),
    );

    final textTheme = ThemeData(brightness: brightness).textTheme.apply(
          bodyColor: cs.onSurface,
          displayColor: cs.onSurface,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: cs,
      scaffoldBackgroundColor: isLight ? AppColors.bg : const Color(0xFF101014),
      fontFamily: null,
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
          height: 1.15,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
          height: 1.2,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(fontSize: 14, height: 1.45),
        bodySmall: textTheme.bodySmall?.copyWith(fontSize: 12, height: 1.4),
        labelLarge: textTheme.labelLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: cs.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: cs.outlineVariant),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? const Color(0xFFF3F3F7) : const Color(0xFF26262E),
        hintStyle: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
        prefixIconColor: cs.onSurfaceVariant,
        suffixIconColor: cs.onSurfaceVariant,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.orange, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.orange,
          minimumSize: const Size.fromHeight(50),
          side: const BorderSide(color: AppColors.orange, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isLight ? const Color(0xFFF3F3F7) : const Color(0xFF26262E),
        selectedColor: AppColors.orange,
        disabledColor: cs.surfaceContainerHighest,
        labelStyle: TextStyle(
          color: cs.onSurface,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cs.surface,
        elevation: 0,
        height: 70,
        indicatorColor: isLight ? AppColors.orangeSoft : const Color(0xFF4A2415),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? AppColors.orange : cs.onSurfaceVariant,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.orange : cs.onSurfaceVariant,
          );
        }),
      ),
      dividerTheme: DividerThemeData(color: cs.outlineVariant, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: cs.onSurface,
        contentTextStyle: TextStyle(color: cs.surface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.orange,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
