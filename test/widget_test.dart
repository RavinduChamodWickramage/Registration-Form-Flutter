import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registration_app/registrationForm.dart';

void main() {
  group('RegistrationForm Widget Tests', () {
    testWidgets('All form fields are rendered', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegistrationForm()));

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('Form fields accept input', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegistrationForm()));

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'John Doe');
      expect(find.text('John Doe'), findsOneWidget);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'john@example.com');
      expect(find.text('john@example.com'), findsOneWidget);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'password123');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirm Password'), 'password123');
    });

    testWidgets('Show/Hide password functionality works',
            (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(home: RegistrationForm()));

          // Enter text in password fields
          await tester.enterText(
              find.widgetWithText(TextFormField, 'Password'), 'testpassword');
          await tester.enterText(
              find.widgetWithText(TextFormField, 'Confirm Password'),
              'testpassword');
          await tester.pump();

          // Initially passwords should be obscured
          var passwordField = tester.widget<EditableText>(
            find.descendant(
              of: find.widgetWithText(TextFormField, 'Password'),
              matching: find.byType(EditableText),
            ),
          );
          var confirmPasswordField = tester.widget<EditableText>(
            find.descendant(
              of: find.widgetWithText(TextFormField, 'Confirm Password'),
              matching: find.byType(EditableText),
            ),
          );

          expect(passwordField.obscureText, isTrue);
          expect(confirmPasswordField.obscureText, isTrue);

          // Find and tap the visibility toggle button for the "Password" field
          await tester.tap(find.descendant(
            of: find.widgetWithText(TextFormField, 'Password'),
            matching: find.byType(IconButton),
          ));
          await tester.pumpAndSettle();

          // After toggling, passwords should be visible
          passwordField = tester.widget<EditableText>(
            find.descendant(
              of: find.widgetWithText(TextFormField, 'Password'),
              matching: find.byType(EditableText),
            ),
          );

          expect(passwordField.obscureText, isFalse);
        });
  });

  group('Form Validation Tests', () {
    testWidgets('Empty form shows validation errors',
            (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(home: RegistrationForm()));

          await tester.tap(find.text('Register'));
          await tester.pump();

          expect(find.text('Please enter your name'), findsOneWidget);
          expect(find.text('Please enter your email'), findsOneWidget);
          expect(find.text('Please enter a password'), findsOneWidget);
          expect(find.text('Please confirm your password'), findsOneWidget);
        });

    testWidgets('Invalid email shows error', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegistrationForm()));

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'invalid-email');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('Password mismatch shows error', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegistrationForm()));

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'password123');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirm Password'),
          'password456');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('Short password shows error', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegistrationForm()));

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), '12345');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(
          find.text('Password must be at least 6 characters'), findsOneWidget);
    });
  });

  group('Real-time Input Display Tests', () {
    testWidgets('Real-time input display shows entered values',
            (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(home: RegistrationForm()));

          await tester.enterText(
              find.widgetWithText(TextFormField, 'Full Name'), 'John Doe');
          await tester.pump();
          expect(find.text('Name: John Doe'), findsOneWidget);

          await tester.enterText(
              find.widgetWithText(TextFormField, 'Email'), 'john@example.com');
          await tester.pump();
          expect(find.text('Email: john@example.com'), findsOneWidget);

          await tester.enterText(
              find.widgetWithText(TextFormField, 'Password'), 'password123');
          await tester.pump();
          expect(find.text('Password: password123'), findsOneWidget);

          await tester.enterText(
              find.widgetWithText(TextFormField, 'Confirm Password'),
              'password123');
          await tester.pump();
          expect(find.text('Confirm Password: password123'), findsOneWidget);
        });
  });

  group('Form Submission Tests', () {
    testWidgets('Successful form submission shows success message',
            (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(home: RegistrationForm()));

          await tester.enterText(
              find.widgetWithText(TextFormField, 'Full Name'), 'John Doe');
          await tester.enterText(
              find.widgetWithText(TextFormField, 'Email'), 'john@example.com');
          await tester.enterText(
              find.widgetWithText(TextFormField, 'Password'), 'password123');
          await tester.enterText(
              find.widgetWithText(TextFormField, 'Confirm Password'),
              'password123');

          await tester.tap(find.text('Register'));
          await tester.pumpAndSettle();

          expect(find.text('Registration Successful!'), findsOneWidget);
        });
  });
}
