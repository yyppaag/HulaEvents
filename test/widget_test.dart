import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hula_events/main.dart';

void main() {
  testWidgets('App should launch successfully', (WidgetTester tester) async {
    // Build our app with ProviderScope and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: HulaEventsApp(),
      ),
    );

    // Allow the app to settle
    await tester.pump();

    // Verify that the app renders without error
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
