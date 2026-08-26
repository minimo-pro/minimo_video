import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/widgets/rolling_counter_text.dart';
import 'package:reel_text/reel_text.dart';

void main() {
  testWidgets('uses calm motion and ignores unchanged formatted value', (
    tester,
  ) async {
    var value = 10.1;
    late StateSetter rebuild;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return RollingCounterText(
              value: value,
              formatter: (number) => number.toInt().toString(),
              style: const TextStyle(fontSize: 20),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    final reel = tester.widget<ReelText>(find.byType(ReelText));
    expect(reel.options.duration, const Duration(milliseconds: 220));
    expect(reel.options.bounce, 0.08);

    rebuild(() => value = 10.2);
    await tester.pump();

    expect(tester.hasRunningAnimations, isFalse);
  });
}
