import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sakti_karanganyar/data/auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<AuthChallenge> registerBudi() => AuthService.register(
        fullName: 'Budi Santoso',
        username: 'budi_s',
        email: 'budi@example.com',
        phone: '081234567890',
        address: 'Jl. Mawar No. 1, Karanganyar',
        birthDate: DateTime(1990, 5, 17),
        password: 'rahasia123',
      );

  test('registrasi menyimpan akun dan membuat kode 6 digit', () async {
    final challenge = await registerBudi();

    expect(challenge.account.fullName, 'Budi Santoso');
    expect(challenge.account.username, 'budi_s');
    expect(challenge.account.email, 'budi@example.com');
    expect(challenge.account.phone, '081234567890');
    expect(challenge.account.birthDate, DateTime(1990, 5, 17));
    expect(challenge.code.length, 6);
    expect(int.tryParse(challenge.code), isNotNull);
    expect(challenge.isRegistration, isTrue);
  });

  test('login berhasil dengan username', () async {
    await registerBudi();
    final challenge = await AuthService.login(
      identifier: 'budi_s',
      password: 'rahasia123',
    );

    expect(challenge.account.username, 'budi_s');
    expect(challenge.isRegistration, isFalse);
    expect(challenge.code.length, 6);
  });

  test('login berhasil dengan email', () async {
    await registerBudi();
    final challenge = await AuthService.login(
      identifier: 'budi@example.com',
      password: 'rahasia123',
    );

    expect(challenge.account.username, 'budi_s');
  });

  test('login gagal bila kata sandi salah', () async {
    await registerBudi();

    await expectLater(
      AuthService.login(identifier: 'budi_s', password: 'salah'),
      throwsA(isA<AuthException>()),
    );
  });

  test('login gagal bila akun tidak ditemukan', () async {
    await expectLater(
      AuthService.login(identifier: 'tidak_ada', password: 'rahasia123'),
      throwsA(isA<AuthException>()),
    );
  });

  test('username dan email tidak boleh ganda', () async {
    await registerBudi();

    await expectLater(
      AuthService.register(
        fullName: 'Budi Lain',
        username: 'BUDI_S',
        email: 'lain@example.com',
        phone: '081234567891',
        address: 'Jl. Melati No. 2, Karanganyar',
        birthDate: DateTime(1992, 2, 2),
        password: 'rahasia123',
      ),
      throwsA(isA<AuthException>()),
    );

    await expectLater(
      AuthService.register(
        fullName: 'Budi Lain',
        username: 'budi_lain',
        email: 'BUDI@example.com',
        phone: '081234567891',
        address: 'Jl. Melati No. 2, Karanganyar',
        birthDate: DateTime(1992, 2, 2),
        password: 'rahasia123',
      ),
      throwsA(isA<AuthException>()),
    );
  });
}
