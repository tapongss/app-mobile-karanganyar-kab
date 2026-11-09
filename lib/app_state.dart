import 'package:flutter/material.dart';

import 'models/models.dart';

/// Pengaturan global aplikasi (aksesibilitas & sesi pengguna).
class AppSettings {
  static final textScale = ValueNotifier<double>(1.0);
  static final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);

  /// Akun yang sedang masuk (null bila belum login).
  static final currentAccount = ValueNotifier<UserAccount?>(null);

  /// Nama pengguna yang sedang masuk.
  static final userName = ValueNotifier<String>('');

  static String get firstName {
    final name = userName.value.trim();
    if (name.isEmpty) return 'Warga';
    return name.split(RegExp(r'\s+')).first;
  }

  static void setSession(UserAccount account) {
    currentAccount.value = account;
    userName.value = account.fullName;
  }

  static void signOut() {
    currentAccount.value = null;
    userName.value = '';
  }
}
