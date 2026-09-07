import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:egy_tracker/core/theme/t_app_theme.dart';

void main() {
  group('AppTheme Verification Tests', () {
    test('Material 3 is strictly enabled for light and dark themes', () {
      final light = AppTheme.lightTheme;
      final dark = AppTheme.darkTheme;

      expect(light.useMaterial3, isTrue);
      expect(dark.useMaterial3, isTrue);
    });

    test('ThemeData defines valid color schemes and distinct currency colors', () {
      final light = AppTheme.lightTheme;
      final dark = AppTheme.darkTheme;

      expect(light.brightness, equals(Brightness.light));
      expect(dark.brightness, equals(Brightness.dark));

      expect(AppTheme.usdColorLight, isNotNull);
      expect(AppTheme.egpColorLight, isNotNull);
      expect(AppTheme.usdColorLight != AppTheme.egpColorLight, isTrue);
    });

    test('AppTheme strictly uses official Google brand colors and dark baseline', () {
      final light = AppTheme.lightTheme;
      final dark = AppTheme.darkTheme;

      // Google 4-color brand tokens
      expect(AppTheme.googleBlue, equals(const Color(0xFF1A73E8)));
      expect(AppTheme.googleBlueDark, equals(const Color(0xFF8AB4F8)));
      expect(AppTheme.googleGreen, equals(const Color(0xFF1E8E3E)));
      expect(AppTheme.googleGreenDark, equals(const Color(0xFF81C995)));
      expect(AppTheme.googleYellow, equals(const Color(0xFFF9AB00)));
      expect(AppTheme.googleYellowDark, equals(const Color(0xFFFDD663)));
      expect(AppTheme.googleRed, equals(const Color(0xFFD93025)));
      expect(AppTheme.googleRedDark, equals(const Color(0xFFF28B82)));

      // Currency mappings
      expect(AppTheme.usdColorLight, equals(AppTheme.googleGreen));
      expect(AppTheme.usdColorDark, equals(AppTheme.googleGreenDark));
      expect(AppTheme.egpColorLight, equals(AppTheme.googleYellow));
      expect(AppTheme.egpColorDark, equals(AppTheme.googleYellowDark));

      // Color scheme primary and surface invariants
      expect(light.colorScheme.primary, equals(AppTheme.googleBlue));
      expect(dark.colorScheme.primary, equals(AppTheme.googleBlueDark));
      expect(light.colorScheme.error, equals(AppTheme.googleRed));
      expect(dark.colorScheme.error, equals(AppTheme.googleRedDark));
      expect(dark.colorScheme.surface, equals(const Color(0xFF121212)));
      expect(light.colorScheme.surface, equals(const Color(0xFFFFFFFF)));
    });

    testWidgets('AppTheme can be applied to MaterialApp and render widgets',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const Scaffold(
            body: Center(
              child: Text('Material 3 Active'),
            ),
          ),
        ),
      );

      expect(find.text('Material 3 Active'), findsOneWidget);
    });
  });
}
