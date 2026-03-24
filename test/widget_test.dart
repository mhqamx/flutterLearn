import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learn/app.dart';

void main() {
  testWidgets('App should launch', (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterLearnApp());
    expect(find.text('Flutter 学习'), findsWidgets);
  });
}
