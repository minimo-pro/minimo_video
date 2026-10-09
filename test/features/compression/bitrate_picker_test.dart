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
      final values = <int?>[];
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
      expect(node.getSemanticsData().increasedValue, '3 Mbps');
      expect(node.getSemanticsData().decreasedValue, '1 Mbps');

      tester.binding.performSemanticsAction(
        SemanticsActionEvent(
          type: SemanticsAction.increase,
          nodeId: node.id,
          viewId: tester.view.viewId,
        ),
      );
      await tester.pumpAndSettle();
      expect(values.last, 3);
      node = sliderNode();
      expect(node.getSemanticsData().value, '3 Mbps');

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

  testWidgets('slider selects whole Mbps with haptic and resets to auto', (
    tester,
  ) async {
    final values = <int?>[];
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
    expect(find.text('5 Mbps', findRichText: true), findsOneWidget);
    await tester.drag(find.byType(Slider), const Offset(30, 0));
    await tester.pumpAndSettle();
    expect(values.last, greaterThan(5));
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
    final values = <int?>[];
    await tester.pumpWidget(_app(5, values.add));
    await tester.pumpWidget(_app(20, values.add));
    await tester.pumpAndSettle();
    final picker = tester.widget<Slider>(find.byType(Slider));
    expect(picker.value, 20);
    expect(values, isEmpty);
    await tester.pumpWidget(_app(null, values.add));
    await tester.pumpAndSettle();
    expect(tester.widget<Slider>(find.byType(Slider)).value, 2);
    expect(values, isEmpty);
  });
}

Widget _app(int? value, ValueChanged<int?> onChanged) => MaterialApp(
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
