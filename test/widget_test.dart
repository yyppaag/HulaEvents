import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hula_events/main.dart';

void main() {
  testWidgets('App should launch successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title appears
    expect(find.text('Hula Events'), findsOneWidget);

    // Verify that there's a floating action button
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Should show empty state when no timelines', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Should show empty state message
    expect(find.text('还没有时间线'), findsOneWidget);
  });
}
