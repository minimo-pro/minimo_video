import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/widgets/app_snack_bar.dart';

void main() {
  const animationDuration = Duration(milliseconds: 1);

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

    AppSnackBar.show(
      context,
      message: 'saved',
      duration: const Duration(milliseconds: 1),
      animationDuration: animationDuration,
    );
    await tester.pump();

    final positioned = tester.widget<Positioned>(
      find.ancestor(of: find.text('saved'), matching: find.byType(Positioned)),
    );

    expect(positioned.top, 14);
    expect(positioned.bottom, isNull);

    await tester.pumpAndSettle();
  });

  testWidgets('duplicate snackbar reuses the visible entry', (tester) async {
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

    AppSnackBar.show(
      context,
      message: 'saved',
      animationDuration: animationDuration,
    );
    await tester.pump();

    AppSnackBar.show(
      context,
      message: 'saved',
      animationDuration: animationDuration,
    );
    await tester.pump();

    expect(find.text('saved'), findsOneWidget);
  });

  testWidgets('duplicate snackbar resets the dismiss timer', (tester) async {
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

    AppSnackBar.show(
      context,
      message: 'saved',
      duration: const Duration(seconds: 1),
      animationDuration: animationDuration,
    );
    await tester.pump(const Duration(milliseconds: 500));

    AppSnackBar.show(
      context,
      message: 'saved',
      duration: const Duration(seconds: 1),
      animationDuration: animationDuration,
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('saved'), findsOneWidget);
  });
}
