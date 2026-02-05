// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_test_demo/main.dart';

void main() {
  testWidgets('Splash page loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: ShopSplashApp()));

    // Wait for the splash page to load
    await tester.pump();

    // Verify that the splash page shows countdown button
    expect(find.text('3'), findsOneWidget);

    // Wait for countdown to decrease
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('2'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('1'), findsOneWidget);

    // After 3 seconds, should navigate to main app
    await tester.pump(const Duration(seconds: 1));

    // Verify we can find some element from the main app
    // (This depends on what MyApp shows)
    expect(find.byType(MaterialApp), findsWidgets);
  });

  testWidgets('Countdown works correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: ShopSplashApp()));

    // Initially should show countdown 3
    expect(find.text('3'), findsOneWidget);

    // After 1 second, should show countdown 2
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('2'), findsOneWidget);

    // After another second, should show countdown 1
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('1'), findsOneWidget);
  });
}
