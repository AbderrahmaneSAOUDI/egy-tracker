import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:egy_tracker/core/components/c_slide_action_card.dart';

void main() {
  group('SlideActionCard Component Tests', () {
    testWidgets('Renders child content and handles basic tap', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SlideActionCard(
              onTap: () => tapped = true,
              child: const SizedBox(
                height: 70,
                child: Text('Main Content'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Main Content'), findsOneWidget);
      await tester.tap(find.text('Main Content'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('Drag right reveals startAction and triggers callback', (tester) async {
      bool startTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SlideActionCard(
              startAction: SlideActionItem(
                icon: Icons.edit,
                label: 'Update',
                backgroundColor: Colors.blue,
                onTrigger: () => startTriggered = true,
              ),
              child: const SizedBox(
                height: 70,
                child: Text('Swipeable Card'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Update'), findsNothing);

      // Perform horizontal drag right
      await tester.timedDrag(
        find.text('Swipeable Card'),
        const Offset(500, 0),
        const Duration(milliseconds: 300),
      );
      await tester.pumpAndSettle();

      expect(startTriggered, isTrue);
    });

    testWidgets('Drag left reveals endAction and triggers callback', (tester) async {
      bool endTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SlideActionCard(
              endAction: SlideActionItem(
                icon: Icons.delete,
                label: 'Remove',
                backgroundColor: Colors.red,
                onTrigger: () => endTriggered = true,
              ),
              child: const SizedBox(
                height: 70,
                child: Text('Swipeable Card'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Remove'), findsNothing);

      // Perform horizontal drag left
      await tester.timedDrag(
        find.text('Swipeable Card'),
        const Offset(-500, 0),
        const Duration(milliseconds: 300),
      );
      await tester.pumpAndSettle();

      expect(endTriggered, isTrue);
    });

    testWidgets('Short drag below threshold springs back without triggering', (tester) async {
      bool triggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SlideActionCard(
              triggerThreshold: 100.0,
              startAction: SlideActionItem(
                icon: Icons.edit,
                label: 'Update',
                onTrigger: () => triggered = true,
              ),
              child: const SizedBox(
                height: 70,
                child: Text('Spring Card'),
              ),
            ),
          ),
        ),
      );

      // Small drag below threshold with zero velocity
      final gesture = await tester.startGesture(tester.getCenter(find.text('Spring Card')));
      await gesture.moveBy(const Offset(20, 0));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(triggered, isFalse);
    });

    testWidgets('Fling with high velocity triggers action even with moderate offset', (tester) async {
      bool editFlingTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SlideActionCard(
              triggerThreshold: 80.0,
              startAction: SlideActionItem(
                icon: Icons.edit,
                label: 'Update',
                backgroundColor: Colors.blue,
                onTrigger: () => editFlingTriggered = true,
              ),
              child: const SizedBox(
                height: 70,
                child: Text('Fling Card'),
              ),
            ),
          ),
        ),
      );

      // Fling right with high velocity
      await tester.fling(
        find.text('Fling Card'),
        const Offset(100, 0),
        1000.0,
      );
      await tester.pumpAndSettle();

      expect(editFlingTriggered, isTrue);
    });

    testWidgets('Respects absence of start or end action by disallowing drag in that direction', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SlideActionCard(
              endAction: SlideActionItem(
                icon: Icons.delete,
                label: 'Remove',
                onTrigger: () {},
              ),
              // No startAction
              child: const SizedBox(
                height: 70,
                child: Text('One Way Card'),
              ),
            ),
          ),
        ),
      );

      // Attempt drag right (towards startAction)
      final gesture = await tester.startGesture(tester.getCenter(find.text('One Way Card')));
      await gesture.moveBy(const Offset(60, 0));
      await tester.pump();

      // No start action should render
      expect(find.byType(SlideActionCard), findsOneWidget);
      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('Action button height matches child height when revealed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SlideActionCard(
              startAction: SlideActionItem(
                icon: Icons.edit,
                label: 'Edit',
                backgroundColor: Colors.blue,
                onTrigger: () {},
              ),
              child: const SizedBox(
                height: 85,
                child: Text('Card Content'),
              ),
            ),
          ),
        ),
      );

      // Drag right to reveal startAction: first move exceeds slop, second moves dragOffset
      final gesture = await tester.startGesture(tester.getCenter(find.text('Card Content')));
      await gesture.moveBy(const Offset(25, 0));
      await tester.pump();
      await gesture.moveBy(const Offset(50, 0));
      await tester.pump();

      expect(find.byIcon(Icons.edit), findsOneWidget);

      // Find the action card container (ancestor of icon)
      final actionButtonFinder = find.ancestor(
        of: find.byIcon(Icons.edit),
        matching: find.byType(Container),
      ).last;

      final buttonSize = tester.getSize(actionButtonFinder);
      final cardSize = tester.getSize(find.text('Card Content'));
      expect(buttonSize.height, equals(cardSize.height));
      expect(buttonSize.height, equals(85.0));

      await gesture.up();
      await tester.pumpAndSettle();
    });
  });
}
