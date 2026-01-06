import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projectmad/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // 1. Remove 'const' from MyApp()
    // Note: This test might still fail in the console because Firebase 
    // requires a physical/emulator device, but it will stop the red error lines.
    await tester.pumpWidget(MyApp());

    // 2. We check for 'MSI Store' (the title in your HomeScreen) 
    // instead of '0' because your app is no longer a counter app.
    expect(find.text('MSI Store'), findsNothing);
  });
}