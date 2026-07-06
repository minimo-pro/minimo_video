import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/widgets/pressable.dart';
import 'package:motor/motor.dart';

void main() {
  testWidgets('scales down while pressed and springs back', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: false),
          child: Center(
            child: Pressable(
              child: SizedBox(key: Key('button'), width: 100, height: 50),
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const Key('button'))),
    );
    await tester.pump();
    expect(
      tester
          .widget<SingleMotionBuilder>(find.byType(SingleMotionBuilder))
          .value,
      0.96,
    );

    await gesture.up();
    await tester.pump();
    expect(
      tester
          .widget<SingleMotionBuilder>(find.byType(SingleMotionBuilder))
          .value,
      1,
    );
  });

  testWidgets('ignores pointer up after disposal', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Pressable(child: SizedBox(width: 100, height: 50)),
      ),
    );
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(SizedBox)),
    );
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await gesture.up();
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
