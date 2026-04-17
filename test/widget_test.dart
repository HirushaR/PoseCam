import 'package:flutter_test/flutter_test.dart';

import 'package:posecam/app.dart';

void main() {
  testWidgets('Home shows Start Session', (WidgetTester tester) async {
    await tester.pumpWidget(const PoseCamApp());
    expect(find.text('Start Session'), findsOneWidget);
  });
}
