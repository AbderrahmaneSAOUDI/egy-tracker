import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:egy_tracker/core/animations/a_dialog_transition.dart';
import 'package:egy_tracker/core/components/c_section_card.dart';
import 'package:egy_tracker/core/models/mod_borrow.dart';
import 'package:egy_tracker/core/models/mod_exchange.dart';
import 'package:egy_tracker/core/models/mod_expense.dart';
import 'package:egy_tracker/core/theme/t_app_theme.dart';
import 'package:egy_tracker/core/components/c_add_exchange_dialog.dart';
import 'package:egy_tracker/core/components/c_add_expense_dialog.dart';
import 'package:egy_tracker/core/components/c_borrow_dialog.dart';
import 'package:egy_tracker/core/components/c_confirmation_dialog.dart';
import 'package:egy_tracker/core/components/c_delete_activity_dialog.dart';
import 'package:egy_tracker/features/home/models/mod_activity_item.dart';

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

      // Initial state: Paid By has 'You' and friendName, Split has '100% Payer', '50 / 50', 'Custom'
      expect(find.text('100% Payer'), findsOneWidget);
      expect(find.text('50 / 50'), findsOneWidget);
      expect(find.text('Custom'), findsOneWidget);

      // Select '50 / 50'
      await tester.tap(find.text('50 / 50'));
      await tester.pumpAndSettle();

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

    testWidgets(
        'Disables save button when expense amount exceeds available cash or is empty, and prevents negative values',
        (tester) async {
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
                    myUsdBalance: 50,
                    myEgpBalance: 1000,
                    onSave: (exp) async => true,
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

      final textFields = find.byType(TextFormField);
      final saveBtnFinder = find.widgetWithText(FilledButton, 'Save');

      // Title and amount are empty -> Save button should be disabled
      expect(tester.widget<FilledButton>(saveBtnFinder).onPressed, isNull);

      // Enter title only
      await tester.enterText(textFields.at(0), 'Coffee');
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(saveBtnFinder).onPressed, isNull);

      // Try entering negative amount "-30" -> negative sign stripped by formatter
      await tester.enterText(textFields.at(1), '-30');
      await tester.pumpAndSettle();
      expect(tester.widget<TextFormField>(textFields.at(1)).controller?.text, '30');
      // 30 <= 1000 EGP owned -> valid, button enabled
      expect(tester.widget<FilledButton>(saveBtnFinder).onPressed, isNotNull);

      // Enter amount exceeding owned EGP (1200 > 1000)
      await tester.enterText(textFields.at(1), '1200');
      await tester.pumpAndSettle();

      // Exceeds available physical cash -> Shows soft warning, but Save button remains enabled (Item 2.1)
      expect(find.textContaining('Amount exceeds available cash'), findsOneWidget);
      expect(tester.widget<FilledButton>(saveBtnFinder).onPressed, isNotNull);

      // Enter amount within balance (400 <= 1000) -> enabled and warning disappears
      await tester.enterText(textFields.at(1), '400');
      await tester.pumpAndSettle();
      expect(find.textContaining('Amount exceeds available cash'), findsNothing);
      expect(tester.widget<FilledButton>(saveBtnFinder).onPressed, isNotNull);

      // Switch to USD (user has 50 USD)
      await tester.tap(find.text('USD'));
      await tester.pumpAndSettle();

      // 400 > 50 USD -> Shows soft warning, Save button remains enabled
      expect(find.textContaining('Amount exceeds available cash'), findsOneWidget);
      expect(tester.widget<FilledButton>(saveBtnFinder).onPressed, isNotNull);

      // 40 <= 50 USD -> Save button enabled, warning disappears
      await tester.enterText(textFields.at(1), '40');
      await tester.pumpAndSettle();
      expect(find.textContaining('Amount exceeds available cash'), findsNothing);
      expect(tester.widget<FilledButton>(saveBtnFinder).onPressed, isNotNull);
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

      // Error message indicates amount exceeds owned money (soft warning)
      expect(find.textContaining('Exceeds owned money'), findsOneWidget);

      // Enter valid amount within owned ($50 <= $100)
      await tester.enterText(textFields.at(0), '50');
      await tester.pumpAndSettle();

      // Try to save
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

    testWidgets(
        'Disables save button when borrow amount exceeds friend cash and blocks negative signs',
        (tester) async {
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
                    friendUsdBalance: 60.0,
                    friendEgpBalance: 1500.0,
                    onSave: (bor) async => true,
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

      final textFields = find.byType(TextFormField);
      final saveBtnFinder = find.widgetWithText(FilledButton, 'Save');

      // Both USD and EGP empty -> disabled
      expect(tester.widget<FilledButton>(saveBtnFinder).onPressed, isNull);

      // Try entering negative value into USD -> negative sign stripped
      await tester.enterText(textFields.at(0), '-20');
      await tester.pumpAndSettle();
      expect(tester.widget<TextFormField>(textFields.at(0)).controller?.text, '20');
      // 20 <= 60 friend USD -> button enabled
      expect(tester.widget<FilledButton>(saveBtnFinder).onPressed, isNotNull);

      // Exceed friend's USD (70 > 60)
      await tester.enterText(textFields.at(0), '70');
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(saveBtnFinder).onPressed, isNull);

      // Reset USD to 0, test EGP exceeding friend's balance (2000 > 1500)
      await tester.enterText(textFields.at(0), '0');
      await tester.enterText(textFields.at(1), '2000');
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(saveBtnFinder).onPressed, isNull);

      // Valid EGP (500 <= 1500) -> button enabled
      await tester.enterText(textFields.at(1), '500');
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(saveBtnFinder).onPressed, isNotNull);
    });

    testWidgets('showAddExpenseDialog with initialExpense renders Edit Expense and pre-fills fields',
        (tester) async {
      Expense? updatedExpense;
      final existingExpense = Expense(
        id: 'exp_existing',
        title: 'Falafel Lunch',
        amount: 150.0,
        currency: 'EGP',
        paidBy: 'me_id',
        splitType: 'default_100',
        mePercentage: 100.0,
        friendPercentage: 0.0,
        date: DateTime(2026, 9, 1),
        createdAt: DateTime(2026, 9, 1),
      );

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
                    initialExpense: existingExpense,
                    onSave: (exp) async {
                      updatedExpense = exp;
                      return true;
                    },
                  );
                },
                child: const Text('Edit Expense'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Edit Expense'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Expense'), findsWidgets);
      expect(find.text('Falafel Lunch'), findsOneWidget);
      expect(find.text('150.00'), findsOneWidget);

      // Modify title and save
      await tester.enterText(find.text('Falafel Lunch'), 'Koshary Feast');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(updatedExpense, isNotNull);
      expect(updatedExpense!.id, 'exp_existing');
      expect(updatedExpense!.title, 'Koshary Feast');
      expect(updatedExpense!.amount, 150.0);
    });

    testWidgets('showAddExchangeDialog with initialExchange renders Edit Exchange and pre-fills fields',
        (tester) async {
      Exchange? updatedExchange;
      final existingExchange = Exchange(
        id: 'exc_existing',
        userId: 'me_id',
        fromCurrency: 'USD',
        fromAmount: 100.0,
        toCurrency: 'EGP',
        toAmount: 4900.0,
        exchangeRate: 49.0,
        date: DateTime(2026, 9, 2),
        createdAt: DateTime(2026, 9, 2),
      );

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
                    myUsdBalance: 500,
                    myEgpBalance: 10000,
                    initialExchange: existingExchange,
                    onSave: (exc) async {
                      updatedExchange = exc;
                      return true;
                    },
                  );
                },
                child: const Text('Edit Exchange'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Edit Exchange'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Exchange'), findsWidgets);
      expect(find.text('100.00'), findsOneWidget);
      expect(find.text('4900.00'), findsOneWidget);

      // Modify toAmount and save
      await tester.enterText(find.text('4900.00'), '5000.00');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(updatedExchange, isNotNull);
      expect(updatedExchange!.id, 'exc_existing');
      expect(updatedExchange!.fromAmount, 100.0);
      expect(updatedExchange!.toAmount, 5000.0);
      expect(updatedExchange!.exchangeRate, 50.0);
    });

    testWidgets('showBorrowDialog with initialBorrow renders Edit Borrow Record and pre-fills fields',
        (tester) async {
      Borrow? updatedBorrow;
      final existingBorrow = Borrow(
        id: 'bor_existing',
        borrowerId: 'me_id',
        lenderId: 'friend_id',
        usdAmount: 40.0,
        egpAmount: 0.0,
        date: DateTime(2026, 9, 3),
        createdAt: DateTime(2026, 9, 3),
      );

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
                    initialBorrow: existingBorrow,
                    onSave: (bor) async {
                      updatedBorrow = bor;
                      return true;
                    },
                  );
                },
                child: const Text('Edit Borrow'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Edit Borrow'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Borrow Record'), findsWidgets);
      expect(find.text('40.00'), findsOneWidget);

      // Update USD amount
      await tester.enterText(find.text('40.00'), '80.00');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(updatedBorrow, isNotNull);
      expect(updatedBorrow!.id, 'bor_existing');
      expect(updatedBorrow!.usdAmount, 80.0);
    });

    testWidgets('showBorrowDialog allows switching to I lent mode and saves with correct roles', (tester) async {
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
                    currentUserId: 'me_uid',
                    currentUserName: 'Me',
                    friendUserId: 'friend_uid',
                    friendUserName: 'Friend',
                    myUsdBalance: 100.0,
                    myEgpBalance: 2000.0,
                    friendUsdBalance: 10.0,
                    friendEgpBalance: 100.0,
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

      // By default it shows I borrowed
      expect(find.text('I borrowed'), findsOneWidget);
      expect(find.text('I lent'), findsOneWidget);

      // Tap on "I lent"
      await tester.tap(find.text('I lent'));
      await tester.pumpAndSettle();

      // Banner updates
      expect(find.text('Lending cash to Friend'), findsOneWidget);

      // Enter amount (35 USD)
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), '35.00');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(savedBorrow, isNotNull);
      expect(savedBorrow!.borrowerId, equals('friend_uid'));
      expect(savedBorrow!.lenderId, equals('me_uid'));
      expect(savedBorrow!.usdAmount, equals(35.0));
    });

    testWidgets('showBorrowDialog shows error SnackBar when onSave fails', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showBorrowDialog(
                    context: context,
                    currentUserId: 'me_uid',
                    currentUserName: 'Me',
                    friendUserId: 'friend_uid',
                    friendUserName: 'Friend',
                    onSave: (bor) async => false, // Failure
                  );
                },
                child: const Text('Open Borrow Fail'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Borrow Fail'));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), '10.00');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(
        find.text('Failed to save borrow record. Please check your connection and try again.'),
        findsOneWidget,
      );
    });
  });

  group('ConfirmationDialog Component Tests', () {
    testWidgets('showConfirmationDialog renders title, message, and buttons, and cancels', (tester) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showConfirmationDialog(
                    context: context,
                    title: 'Delete Item?',
                    message: 'This item will be permanently removed.',
                    confirmLabel: 'Delete Now',
                    cancelLabel: 'Nevermind',
                  );
                },
                child: const Text('Confirm Action'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Confirm Action'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Item?'), findsOneWidget);
      expect(find.text('This item will be permanently removed.'), findsOneWidget);
      expect(find.text('Delete Now'), findsOneWidget);
      expect(find.text('Nevermind'), findsOneWidget);

      // Tap Cancel
      await tester.tap(find.text('Nevermind'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Item?'), findsNothing);
      expect(result, isFalse);
    });

    testWidgets('showConfirmationDialog confirms and invokes onConfirm', (tester) async {
      bool confirmInvoked = false;
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showConfirmationDialog(
                    context: context,
                    title: 'Confirm Operation',
                    message: 'Are you sure?',
                    onConfirm: () async {
                      confirmInvoked = true;
                      return true;
                    },
                  );
                },
                child: const Text('Open Confirm'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Confirm'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(confirmInvoked, isTrue);
      expect(result, isTrue);
    });

    testWidgets('showDeleteActivityDialog correctly adapts for Expense, Exchange, and Borrow', (tester) async {
      final exp = Expense(
        id: 'exp_1',
        title: 'Dinner at Nile',
        amount: 250,
        currency: 'EGP',
        paidBy: 'u1',
        splitType: 'fifty_fifty',
        mePercentage: 50,
        friendPercentage: 50,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );

      bool deleted = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDeleteActivityDialog(
                  context: context,
                  item: ActivityItem.expense(exp),
                  onDelete: () async => deleted = true,
                ),
                child: const Text('Delete Exp'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Delete Exp'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Expense'), findsOneWidget);
      expect(find.text('Are you sure you want to delete "Dinner at Nile"? Cash balances will be updated.'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(deleted, isTrue);
    });
  });
}
