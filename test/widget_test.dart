// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bank_sampah_gt/daftar_anggota.dart';
import 'package:bank_sampah_gt/jenis_sampah.dart';
import 'package:bank_sampah_gt/tambah_anggota.dart';
import 'package:bank_sampah_gt/main.dart';

void main() {
  testWidgets('Test Drawer Navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const BankSampahGT());

    // Open the drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle(); // Wait for drawer to fully open

    // Test each ListTile in the drawer
    await _testDrawerMenuItem(tester, Icons.dashboard, 'Dashboard');
    await _testDrawerMenuItem(tester, Icons.payment, 'Transaksi Sampah');
    await _testDrawerMenuItem(tester, Icons.category, 'Jenis Sampah',
        navigateTo: const DaftarJenisSampah());
    await _testDrawerMenuItem(tester, Icons.print, 'Print / Ekspor Data');
    await _testDrawerMenuItem(tester, Icons.person, 'Anggota',
        navigateTo: const DaftarAnggota());
    await _testDrawerMenuItem(tester, Icons.person_add, 'Tambah Anggota',
        navigateTo: const TambahAnggota());
  });
}

Future<void> _testDrawerMenuItem(
    WidgetTester tester, IconData icon, String text,
    {Widget? navigateTo}) async {
  // Tap on the ListTile with the given text and icon
  await tester.tap(find.widgetWithIcon(ListTile, icon));
  await tester.pumpAndSettle(); // Wait for navigation to complete

  // Verify the drawer is closed
  expect(find.text('Menu'), findsNothing);

  // Verify text is present on the screen
  expect(find.text(text), findsOneWidget);

  // If a screen to navigate to is provided, verify it's on the screen
  if (navigateTo != null) {
    expect(find.byWidget(navigateTo), findsOneWidget);
  }
}
