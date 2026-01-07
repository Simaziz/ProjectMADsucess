import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projectmad/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Check that "MSI Store" is not currently on screen (example text from HomeScreen).
    expect(find.text('MSI Store'), findsNothing);
  });
}
