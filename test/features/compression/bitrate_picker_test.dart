import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/presentation/widgets/bitrate_picker.dart';
import 'package:minimo_video/generated/l10n.dart';

void main() {
  testWidgets('semantics announces auto and numeric values when adjusted', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    try {
      final values = <double?>[];
      SemanticsNode sliderNode() => tester
          .getSemantics(find.byType(Slider))
          .debugListChildrenInOrder(DebugSemanticsDumpOrder.traversalOrder)
          .singleWhere(
            (node) =>
                node.getSemanticsData().hasAction(SemanticsAction.increase),
          );
      await tester.pumpWidget(_app(null, values.add));
      var node = sliderNode();
      expect(node.getSemanticsData().value, 'auto');
      expect(node.getSemanticsData().increasedValue, '2.5 Mbps');
      expect(node.getSemanticsData().decreasedValue, '1.5 Mbps');

      tester.binding.performSemanticsAction(
        SemanticsActionEvent(
          type: SemanticsAction.increase,
          nodeId: node.id,
          viewId: tester.view.viewId,
        ),
      );
      await tester.pumpAndSettle();
      expect(values.last, 2.5);
      node = sliderNode();
      expect(node.getSemanticsData().value, '2.5 Mbps');

      await tester.tap(find.text('auto'));
      await tester.pumpAndSettle();
      expect(sliderNode().getSemanticsData().value, 'auto');
      await tester.pumpWidget(_app(5, values.add));
      await tester.pumpAndSettle();
      expect(sliderNode().getSemanticsData().value, '5 Mbps');
    } finally {
      handle.dispose();
    }
  });

  testWidgets('slider selects fractional Mbps with haptic and resets to auto', (
    tester,
  ) async {
    final values = <double?>[];
    final haptics = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'HapticFeedback.vibrate') haptics.add(call);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.pumpWidget(_app(5, values.add));
    final picker = tester.widget<Slider>(find.byType(Slider));
    expect(picker.value, 5);
    expect(find.text('5 Mbps'), findsOneWidget);
    final start = tester.getTopLeft(find.byType(Slider));
    // 1.5 Mbps is the second discrete position after the 14px track inset.
    await tester.tapAt(start + const Offset(14 + 252 / 38, 24));
    await tester.pumpAndSettle();
    expect(values.last, 1.5);
    expect(find.text('1.5 Mbps'), findsOneWidget);
    await tester.drag(find.byType(Slider), const Offset(30, 0));
    await tester.pumpAndSettle();
    expect(values.last, greaterThan(1.5));
    expect(values.last, lessThanOrEqualTo(20));
    expect(haptics.last.arguments, 'HapticFeedbackType.selectionClick');
    await tester.tap(find.text('auto').last);
    await tester.pumpAndSettle();
    expect(values.last, isNull);
    expect(tester.widget<Slider>(find.byType(Slider)).value, 2);
  });

  testWidgets('slider follows external settings without haptic or callbacks', (
    tester,
  ) async {
    final values = <double?>[];
    await tester.pumpWidget(_app(5, values.add));
    await tester.pumpWidget(_app(19.5, values.add));
    await tester.pumpAndSettle();
    final picker = tester.widget<Slider>(find.byType(Slider));
    expect(picker.value, 19.5);
    expect(values, isEmpty);
    await tester.pumpWidget(_app(null, values.add));
    await tester.pumpAndSettle();
    expect(tester.widget<Slider>(find.byType(Slider)).value, 2);
    expect(values, isEmpty);
  });
}

Widget _app(double? value, ValueChanged<double?> onChanged) => MaterialApp(
  localizationsDelegates: const [S.delegate],
  home: Scaffold(
    body: Center(
      child: SizedBox(
        width: 280,
        child: BitratePicker(value: value, onChanged: onChanged),
      ),
    ),
  ),
);
