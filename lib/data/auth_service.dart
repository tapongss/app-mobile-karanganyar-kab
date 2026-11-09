import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

/// Hasil proses login/registrasi yang masih menunggu verifikasi email.
class AuthChallenge {
  final UserAccount account;
  final String code;
  final bool isRegistration;

  const AuthChallenge({
    required this.account,
    required this.code,
    required this.isRegistration,
  });
}

/// Penyimpanan akun lokal (prototipe).
///
/// Pada implementasi produksi, registrasi, login, dan pengiriman kode
/// verifikasi email harus dilakukan melalui API resmi Diskominfo.
class AuthService {
  static const _accountsKey = 'karanganyar_accounts_v1';
  static final _random = Random.secure();

  static Future<List<UserAccount>> _accounts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_accountsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => UserAccount.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _save(List<UserAccount> accounts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _accountsKey,
      jsonEncode(accounts.map((a) => a.toJson()).toList()),
    );
  }

  static String generateCode() =>
      (100000 + _random.nextInt(900000)).toString();

  static Future<AuthChallenge> register({
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required String address,
    required DateTime birthDate,
    required String password,
  }) async {
    final accounts = await _accounts();
    final uname = username.trim().toLowerCase();
    final mail = email.trim().toLowerCase();

    if (accounts.any((a) => a.username.toLowerCase() == uname)) {
      throw const AuthException('Username sudah digunakan. Coba yang lain.');
    }
    if (accounts.any((a) => a.email.toLowerCase() == mail)) {
      throw const AuthException('Email sudah terdaftar. Silakan masuk.');
    }

    final account = UserAccount(
      fullName: fullName.trim(),
      username: username.trim(),
      email: email.trim(),
      phone: phone.trim(),
      address: address.trim(),
      birthDate: birthDate,
      password: password,
    );
    accounts.add(account);
    await _save(accounts);

    return AuthChallenge(
      account: account,
      code: generateCode(),
      isRegistration: true,
    );
  }

  static Future<AuthChallenge> login({
    required String identifier,
    required String password,
  }) async {
    final accounts = await _accounts();
    final key = identifier.trim().toLowerCase();

    UserAccount? found;
    for (final a in accounts) {
      if (a.username.toLowerCase() == key ||
          a.email.toLowerCase() == key) {
        found = a;
        break;
      }
    }
    if (found == null) {
      throw const AuthException(
          'Akun tidak ditemukan. Silakan daftar terlebih dahulu.');
    }
    if (found.password != password) {
      throw const AuthException('Kata sandi salah. Silakan coba lagi.');
    }

    return AuthChallenge(
      account: found,
      code: generateCode(),
      isRegistration: false,
    );
  }

  static Future<UserAccount?> findByUsername(String username) async {
    final accounts = await _accounts();
    final key = username.trim().toLowerCase();
    for (final a in accounts) {
      if (a.username.toLowerCase() == key) return a;
    }
    return null;
  }
}
