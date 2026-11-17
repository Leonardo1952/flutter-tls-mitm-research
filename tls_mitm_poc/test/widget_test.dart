import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tls_mitm_poc/main.dart';

void main() {
  testWidgets('Home page renders the three quote-source tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RateTodayApp());
    await tester.pump();

    expect(find.text('Rate Today'), findsOneWidget);
    expect(find.text('EasyFX'), findsOneWidget);
    expect(find.text('DollarTrack'), findsOneWidget);
    expect(find.text('FastFX'), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);
  });
}
