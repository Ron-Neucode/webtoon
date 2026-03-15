import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webtoon/main.dart';
import 'package:webtoon/screens/login_screen.dart';
import 'package:webtoon/screens/dashboard_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('App Tests', () {
    testWidgets('App starts with LoginScreen if not logged in', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp(loggedInUsername: null));
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('App starts with DashboardScreen if logged in', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp(loggedInUsername: 'testuser'));
      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(find.text('MangaVerse'), findsOneWidget);
    });

    testWidgets('LoginScreen UI components', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Fields and buttons
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

      // Toggle to register
      await tester.tap(find.text("Don't have an account? Register"));
      await tester.pumpAndSettle();
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('Dashboard bottom nav switches tabs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));
      expect(find.text('MangaVerse'), findsOneWidget);

      // Initial home tab
      expect(
        find.byType(ListView),
        findsNothing,
      ); // Home tab has MasonryGridView, hard to test type

      // Tap categories
      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();
      expect(find.byType(FilterChip), findsWidgets);

      // Tap library
      await tester.tap(find.text('Library'));
      await tester.pumpAndSettle();

      // Tap profile
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });
}
