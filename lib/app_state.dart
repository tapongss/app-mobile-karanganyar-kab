import 'package:flutter/material.dart';

/// Pengaturan global aplikasi (aksesibilitas & sesi pengguna).
class AppSettings {
  static final textScale = ValueNotifier<double>(1.0);
  static final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);

  /// Nama pengguna hasil halaman "Kenalan dulu yuk".
  static final userName = ValueNotifier<String>('');

  static String get firstName {
    final name = userName.value.trim();
    if (name.isEmpty) return 'Warga';
    return name.split(RegExp(r'\s+')).first;
  }

  static void signOut() {
    userName.value = '';
  }
}
