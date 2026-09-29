import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:sanctumiq/main.dart';

void main() {
  testWidgets('landing page lays out across desktop and mobile widths',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;

    for (final size in [const Size(1440, 1000), const Size(390, 844)]) {
      tester.view.physicalSize = size;
      await tester.pumpWidget(const SanctumIQApp());
      await tester.pumpAndSettle();

      expect(find.text('SMART BAG SECURITY / READY'), findsOneWidget);
      expect(find.text('EXPLORE THE FEATURES'), findsOneWidget);
      expect(tester.takeException(), isNull);

      final scrollView = find.byType(CustomScrollView);
      for (var section = 0; section < 10; section++) {
        await tester.drag(scrollView, const Offset(0, -700));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    }
  });
}
