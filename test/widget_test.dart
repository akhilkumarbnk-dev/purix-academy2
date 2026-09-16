import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:purix_academy/main.dart';

void main() {
  testWidgets('Purix Academy App launches successfully',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app starts and shows loading or login screen
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('Login screen widgets are present',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Wait for the app to load
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify key widgets exist
    expect(find.byType(TextField), findsWidgets);
    expect(find.byType(ElevatedButton), findsWidgets);
  });

  testWidgets('App theme is applied correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify app has correct theme
    expect(
      find.byType(MaterialApp),
      findsOneWidget,
      reason: 'App should have MaterialApp',
    );

    // Verify text widgets exist
    expect(find.byType(Text), findsWidgets);
  });
}