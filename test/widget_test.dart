import 'package:flutter_test/flutter_test.dart';

import 'package:egy_tracker/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('egy_tracker'), findsOneWidget);
  });
}
