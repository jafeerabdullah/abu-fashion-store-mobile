import 'package:flutter_test/flutter_test.dart';

import 'package:abu_store/app.dart';

void main() {
  testWidgets('shows login screen on launch', (WidgetTester tester) async {
    await tester.pumpWidget(const AbuFashionApp());
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
  });
}
