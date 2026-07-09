import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/widgets/app_snack_bar.dart';

void main() {
  testWidgets('snackbar is pinned to the top overlay edge', (tester) async {
    late BuildContext context;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (builderContext) {
            context = builderContext;
            return const SizedBox();
          },
        ),
      ),
    );

    AppSnackBar.show(context, message: 'saved');
    await tester.pump();

    final positioned = tester.widget<Positioned>(
      find.ancestor(of: find.text('saved'), matching: find.byType(Positioned)),
    );

    expect(positioned.top, 14);
    expect(positioned.bottom, isNull);
  });
}
