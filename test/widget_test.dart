import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ki_sun/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KiSunApp());

    // Verify that the Onboarding screen shows up (since it's the initial route)
    // We look for "Sunny" or "Welcome to Ki-Sun" text
    expect(find.text('Sunny ☀️'), findsOneWidget);
    expect(find.text('Welcome to Ki-Sun'), findsOneWidget);
  });
}
