import 'package:flutter_test/flutter_test.dart';
import 'package:nostalplay/app/app.dart';

void main() {
  testWidgets('app boots and shows title', (tester) async {
    await tester.pumpWidget(const NostalPlayApp());
    expect(find.text('NOSTALPLAY'), findsOneWidget);
    expect(find.text('Chọn băng để chơi'), findsOneWidget);
  });
}
