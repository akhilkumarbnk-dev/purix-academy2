import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:purix_academy/main.dart';

void main() {
  testWidgets('Purix Academy app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PurixAcademyApp(isLoggedIn: false));

    // Verify that the MaterialApp loads successfully
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}