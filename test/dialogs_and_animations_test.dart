import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:egy_tracker/core/animations/a_dialog_transition.dart';
import 'package:egy_tracker/core/components/c_section_card.dart';
import 'package:egy_tracker/core/models/mod_borrow.dart';
import 'package:egy_tracker/core/models/mod_exchange.dart';
import 'package:egy_tracker/core/models/mod_expense.dart';
import 'package:egy_tracker/core/theme/t_app_theme.dart';
import 'package:egy_tracker/features/home/components/c_add_exchange_dialog.dart';
import 'package:egy_tracker/features/home/components/c_add_expense_dialog.dart';
import 'package:egy_tracker/features/home/components/c_borrow_dialog.dart';

void main() {
  group('Animated Dialog & SectionCard Animation Tests', () {
    testWidgets('showAnimatedDialog opens with scale/fade transition and closes',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showAnimatedDialog<void>(
                    context: context,
                    builder: (dialogCtx) => const AlertDialog(
                      title: Text('Test Dialog'),
                      content: Text('Animated Content'),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Test Dialog'), findsOneWidget);
      expect(find.text('Animated Content'), findsOneWidget);

      // Close dialog
      Navigator.of(tester.element(find.text('Test Dialog'))).pop();
      await tester.pumpAndSettle();

      expect(find.text('Test Dialog'), findsNothing);
    });

    testWidgets('SectionCard animates in and renders title and child',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: SectionCard(
              icon: Icons.star,
              title: 'Card Title',
              child: Text('Card Content Inside'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Card Title'), findsOneWidget);
      expect(find.text('Card Content Inside'), findsOneWidget);
    });
  });

  group('Add Expense Dialog Tests', () {
    testWidgets(
        'Selecting Both shows split options without who paid the bill prompt',
        (tester) async {
      Expense? savedExpense;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showAddExpenseDialog(
                    context: context,
                    currentUserId: 'me_id',
                    currentUserName: 'Me',
                    friendUserId: 'friend_id',
                    friendUserName: 'Friend',
                    myUsdBalance: 200,
                    myEgpBalance: 5000,
                    onSave: (exp) async {
                      savedExpense = exp;
                      return true;
                    },
                  );
                },
                child: const Text('Open Expense'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Expense'));
      await tester.pumpAndSettle();

      // Initial state: Paid By is 'You' -> split is hidden
      expect(find.text('50 / 50'), findsNothing);
      expect(find.text('Who paid the bill?'), findsNothing);

      // Select 'Both'
      await tester.tap(find.text('Both'));
      await tester.pumpAndSettle();

      // Split options are now visible
      expect(find.text('50 / 50'), findsOneWidget);
      expect(find.text('Custom'), findsOneWidget);

      // Invariant: 'Who paid the bill?' must NOT exist
      expect(find.text('Who paid the bill?'), findsNothing);

      // Reset to now button is present
      expect(find.byTooltip('Reset to now'), findsOneWidget);
      await tester.tap(find.byTooltip('Reset to now'));
      await tester.pumpAndSettle();

      // Enter details and save
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Lunch');
      await tester.enterText(textFields.at(1), '100');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(savedExpense, isNotNull);
      expect(savedExpense!.title, 'Lunch');
      expect(savedExpense!.paidBy, 'me_id');
      expect(savedExpense!.splitType, 'fifty_fifty');
    });
  });

  group('Add Exchange Dialog Tests', () {
    testWidgets(
        'Validates that amount given cannot exceed owned money and auto-calculates rate',
        (tester) async {
      Exchange? savedExchange;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showAddExchangeDialog(
                    context: context,
                    currentUserId: 'me_id',
                    currentUserName: 'Me',
                    myUsdBalance: 100.0, // Only $100 owned
                    myEgpBalance: 2000.0,
                    onSave: (exc) async {
                      savedExchange = exc;
                      return true;
                    },
                  );
                },
                child: const Text('Open Exchange'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Exchange'));
      await tester.pumpAndSettle();

      // Verify no exchange rate input exists
      expect(find.text('Exchange Rate (1 USD = X EGP)'), findsNothing);

      // Enter amount given exceeding owned USD ($150 > $100)
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), '150');
      await tester.enterText(textFields.at(1), '7500');
      await tester.pumpAndSettle();

      // Try to save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Error message indicates amount exceeds owned money
      expect(find.textContaining('Exceeds owned money'), findsOneWidget);
      expect(savedExchange, isNull);

      // Enter valid amount within owned ($50 <= $100)
      await tester.enterText(textFields.at(0), '50');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Successfully saved with rate auto-computed (7500 / 50 = 150)
      expect(savedExchange, isNotNull);
      expect(savedExchange!.fromAmount, 50.0);
      expect(savedExchange!.toAmount, 7500.0);
      expect(savedExchange!.exchangeRate, 150.0);
    });
  });

  group('Borrow Currency Dialog Tests', () {
    testWidgets(
        'Renders EGP payments icon and allows resetting date to now',
        (tester) async {
      Borrow? savedBorrow;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showBorrowDialog(
                    context: context,
                    currentUserId: 'me_id',
                    currentUserName: 'Me',
                    friendUserId: 'friend_id',
                    friendUserName: 'Friend',
                    onSave: (bor) async {
                      savedBorrow = bor;
                      return true;
                    },
                  );
                },
                child: const Text('Open Borrow'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Borrow'));
      await tester.pumpAndSettle();

      // EGP payments icon present
      expect(find.byIcon(Icons.payments_outlined), findsOneWidget);

      // Reset to now button present
      expect(find.byTooltip('Reset to now'), findsOneWidget);
      await tester.tap(find.byTooltip('Reset to now'));
      await tester.pumpAndSettle();

      // Enter borrow amounts
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), '20');
      await tester.enterText(textFields.at(1), '500');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(savedBorrow, isNotNull);
      expect(savedBorrow!.usdAmount, 20.0);
      expect(savedBorrow!.egpAmount, 500.0);
    });
  });
}
