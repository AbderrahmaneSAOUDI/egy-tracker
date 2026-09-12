import 'package:egy_tracker/core/animations/a_animated_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnimatedCounter & AnimatedCurrencyCounter Tests', () {
    testWidgets('AnimatedCounter starts at 0 and increments to target value',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedCounter(
              value: 100.0,
              duration: const Duration(milliseconds: 500),
              builder: (context, val) => Text(val.toStringAsFixed(0)),
            ),
          ),
        ),
      );

      // At t=0, starts at 0
      expect(find.text('0'), findsOneWidget);

      // Mid-animation pump
      await tester.pump(const Duration(milliseconds: 250));
      // Should be greater than 0 and less than 100
      final intermediateText = find.byType(Text);
      final widget = tester.widget<Text>(intermediateText);
      final intermediateValue = double.parse(widget.data!);
      expect(intermediateValue, greaterThanOrEqualTo(0));
      expect(intermediateValue, lessThanOrEqualTo(100));

      // After settling, reaches 100
      await tester.pumpAndSettle();
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('AnimatedCurrencyCounter formats USD currency correctly',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedCurrencyCounter(
              value: 250.50,
              currency: 'USD',
              duration: Duration(milliseconds: 400),
            ),
          ),
        ),
      );

      // At start
      expect(find.text('\$0.00'), findsOneWidget);

      // Settle
      await tester.pumpAndSettle();
      expect(find.text('\$250.50'), findsOneWidget);
    });

    testWidgets('AnimatedCurrencyCounter formats EGP currency correctly',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedCurrencyCounter(
              value: 12500.0,
              currency: 'EGP',
              duration: Duration(milliseconds: 400),
            ),
          ),
        ),
      );

      // At start
      expect(find.text('0.00 EGP'), findsOneWidget);

      // Settle
      await tester.pumpAndSettle();
      expect(find.text('12,500.00 EGP'), findsOneWidget);
    });

    testWidgets('AnimatedCurrencyCounter animates to new value when updated in Firebase',
        (tester) async {
      double balance = 500.0;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    AnimatedCurrencyCounter(
                      value: balance,
                      currency: 'USD',
                      duration: const Duration(milliseconds: 500),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          balance = 750.0; // Simulate balance update from Firestore
                        });
                      },
                      child: const Text('Update Balance'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      // Initial settle: $500.00
      await tester.pumpAndSettle();
      expect(find.text('\$500.00'), findsOneWidget);

      // Trigger balance update to $750.00
      await tester.tap(find.text('Update Balance'));
      await tester.pump();

      // Halfway through the update
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('\$500.00'), findsNothing);
      expect(find.text('\$750.00'), findsNothing);

      // Completes animation to new value
      await tester.pumpAndSettle();
      expect(find.text('\$750.00'), findsOneWidget);
    });

    testWidgets('AnimatedCurrencyCounter handles negative balances properly',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedCurrencyCounter(
              value: -150.75,
              currency: 'USD',
              duration: Duration(milliseconds: 400),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('-\$150.75'), findsOneWidget);
    });

    testWidgets(
        'AnimatedCurrencyCounter animates from zero when data arrives after initial 0',
        (tester) async {
      double balance = 0.0;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    AnimatedCurrencyCounter(
                      value: balance,
                      currency: 'USD',
                      duration: const Duration(milliseconds: 500),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          balance = 300.0;
                        });
                      },
                      child: const Text('Load Data'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      // Initially at 0
      expect(find.text('\$0.00'), findsOneWidget);

      // Load data (simulates first Firestore snapshot arrival)
      await tester.tap(find.text('Load Data'));
      await tester.pump();

      // Mid-flight check: should be between 0 and 300
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('\$0.00'), findsNothing);
      expect(find.text('\$300.00'), findsNothing);

      // Settles to 300.0
      await tester.pumpAndSettle();
      expect(find.text('\$300.00'), findsOneWidget);
    });

    testWidgets(
        'PageVisitScope causes counter to re-run from 0 on page switch/revisit',
        (tester) async {
      int visitToken = 1;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    PageVisitScope(
                      token: visitToken,
                      child: const AnimatedCurrencyCounter(
                        value: 500.0,
                        currency: 'USD',
                        duration: Duration(milliseconds: 500),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          visitToken++; // Simulates switching back to this tab
                        });
                      },
                      child: const Text('Switch Page'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      // Initially at 0, then settles at $500.00
      expect(find.text('\$0.00'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('\$500.00'), findsOneWidget);

      // Simulate switching to the page again
      await tester.tap(find.text('Switch Page'));
      await tester.pump();

      // Immediately upon revisit, it resets to $0.00 and starts animating from zero
      expect(find.text('\$0.00'), findsOneWidget);
      expect(find.text('\$500.00'), findsNothing);

      // Mid-flight pump
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('\$0.00'), findsNothing);
      expect(find.text('\$500.00'), findsNothing);

      // Settles back to $500.00
      await tester.pumpAndSettle();
      expect(find.text('\$500.00'), findsOneWidget);
    });

    testWidgets('AnimatedCounter defaults to 1300ms duration', (tester) async {
      final counter = AnimatedCounter(
        value: 100.0,
        builder: (context, val) => const SizedBox(),
      );
      expect(counter.duration, equals(const Duration(milliseconds: 1300)));

      const currencyCounter = AnimatedCurrencyCounter(
        value: 100.0,
        currency: 'USD',
      );
      expect(currencyCounter.duration, equals(const Duration(milliseconds: 1300)));
    });
  });
}
