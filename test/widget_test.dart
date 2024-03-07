import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notepad/main.dart';

void main() {
  testWidgets('Notepad UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(NotepadApp());

    // Verify that our title is rendered.
    expect(find.text('Notepad'), findsOneWidget);

    // Verify that text field is rendered.
    expect(find.byType(TextField), findsOneWidget);

    // Enter some text into the text field.
    await tester.enterText(find.byType(TextField), 'Test note');

    // Tap the save button.
    await tester.tap(find.byType(FloatingActionButton));

    // Wait for the save operation to complete.
    await tester.pumpAndSettle();

    // Verify that the text has been saved.
    expect(find.text('Test note'), findsOneWidget);
  });
}
