import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bank_sampah_gt/main.dart';

void main() {
  testWidgets('Test Drawer Navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const BankSampahGT());

    // Open the drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle(); // Wait for drawer to fully open

    // Verify that the drawer header 'Menu' is present
    expect(find.text('Menu'), findsOneWidget);

    // Close the drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle(); // Wait for drawer to fully close

    // Verify that the 'Menu' header is no longer present
    expect(find.text(''), findsNothing);
  });
}
