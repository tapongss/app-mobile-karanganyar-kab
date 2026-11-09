import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakti_karanganyar/app_state.dart';
import 'package:sakti_karanganyar/data/auth_service.dart';
import 'package:sakti_karanganyar/models/models.dart';
import 'package:sakti_karanganyar/screens/home_shell.dart';
import 'package:sakti_karanganyar/screens/verification_screen.dart';

void main() {
  final account = UserAccount(
    fullName: 'Budi Santoso',
    username: 'budi_s',
    email: 'budi@example.com',
    phone: '081234567890',
    address: 'Jl. Mawar No. 1, Karanganyar',
    birthDate: DateTime(1990, 5, 17),
    password: 'rahasia123',
  );

  AuthChallenge challenge({bool isRegistration = true}) => AuthChallenge(
        account: account,
        code: '123456',
        isRegistration: isRegistration,
      );

  setUp(AppSettings.signOut);
  tearDown(AppSettings.signOut);

  Future<void> pumpScreen(WidgetTester tester, AuthChallenge c) async {
    await tester.pumpWidget(
      MaterialApp(home: VerificationScreen(challenge: c)),
    );
    await tester.pump();
  }

  testWidgets('menampilkan email tujuan dan kode demo', (tester) async {
    await pumpScreen(tester, challenge());

    expect(find.text('Cek email Anda'), findsOneWidget);
    expect(
      find.textContaining('budi@example.com', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('Gunakan kode: 123456'), findsOneWidget);
    expect(find.text('Verifikasi & Masuk'), findsOneWidget);
  });

  testWidgets('kode salah menampilkan pesan kesalahan', (tester) async {
    await pumpScreen(tester, challenge());

    await tester.enterText(find.byType(TextField), '000000');
    await tester.tap(find.text('Verifikasi & Masuk'));
    await tester.pump();

    expect(
      find.text('Kode verifikasi salah. Periksa kembali email Anda.'),
      findsOneWidget,
    );
    expect(AppSettings.currentAccount.value, isNull);
  });

  testWidgets('kode benar menyimpan sesi dan membuka beranda', (tester) async {
    await pumpScreen(tester, challenge());

    await tester.enterText(find.byType(TextField), '123456');
    await tester.tap(find.text('Verifikasi & Masuk'));
    await tester.pumpAndSettle();

    expect(AppSettings.currentAccount.value, account);
    expect(AppSettings.userName.value, 'Budi Santoso');
    expect(find.byType(HomeShell), findsOneWidget);
    expect(find.byType(VerificationScreen), findsNothing);
  });

  testWidgets('tombol Isi mengisi kode demo otomatis', (tester) async {
    await pumpScreen(tester, challenge());

    await tester.tap(find.text('Isi'));
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text, '123456');
  });
}
