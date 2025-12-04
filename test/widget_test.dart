import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic widget test', (WidgetTester tester) async {
    // Build a simple test widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Indonesia Stays Test'),
          ),
          body: const Center(
            child: Text('Test Widget'),
          ),
        ),
      ),
    );

    // Verify the test widget works
    expect(find.text('Test Widget'), findsOneWidget);
    expect(find.text('Indonesia Stays Test'), findsOneWidget);
  });
}
