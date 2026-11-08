import 'package:flutter_test/flutter_test.dart';

import 'package:sakti_karanganyar/main.dart';

void main() {
  testWidgets('menampilkan halaman splash', (WidgetTester tester) async {
    await tester.pumpWidget(const KaranganyarApp());
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('KARANGANYAR\nKAB'), findsOneWidget);
    expect(find.text('Mulai'), findsOneWidget);
    expect(
      find.text('Portal Resmi Pemerintah\nKabupaten Karanganyar'),
      findsOneWidget,
    );
  });
}
