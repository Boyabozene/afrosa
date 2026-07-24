import 'package:flutter_test/flutter_test.dart';
import 'package:afrosa/main.dart';

void main() {
  testWidgets('App démarre correctement', (WidgetTester tester) async {
    await tester.pumpWidget(const AfrosaApp());
    expect(find.byType(AfrosaApp), findsOneWidget);
  });
}