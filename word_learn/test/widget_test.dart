import 'package:flutter_test/flutter_test.dart';

import 'package:word_learn/app.dart';

void main() {
  testWidgets('App shows WordLearn on splash then navigates to welcome',
      (WidgetTester tester) async {
    await tester.pumpWidget(const WordLearnApp());
    expect(find.text('WordLearn'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('GET STARTED'), findsOneWidget);
  });
}
