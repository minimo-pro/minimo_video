import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/domain/video_pick_source.dart';
import 'package:minimo_video/features/compression/presentation/widgets/video_pick_source_sheet.dart';
import 'package:minimo_video/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  testWidgets('pick source sheet returns gallery', (tester) async {
    VideoPickSource? chosen;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                chosen = await showVideoPickSourceSheet(context);
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('from gallery'));
    await tester.pumpAndSettle();

    expect(chosen, VideoPickSource.gallery);
  });

  testWidgets('pick source sheet returns files', (tester) async {
    VideoPickSource? chosen;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                chosen = await showVideoPickSourceSheet(context);
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('from files'));
    await tester.pumpAndSettle();

    expect(chosen, VideoPickSource.files);
  });

  testWidgets('reuses the open source sheet for repeated requests', (
    tester,
  ) async {
    var reusedOpenSheet = false;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () {
                final first = showVideoPickSourceSheet(context);
                final second = showVideoPickSourceSheet(context);
                reusedOpenSheet = identical(first, second);
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pump();

    expect(reusedOpenSheet, isTrue);
    expect(find.text('from gallery'), findsOneWidget);
    expect(find.text('from files'), findsOneWidget);
  });

  testWidgets('waits for the sheet to close before returning the source', (
    tester,
  ) async {
    var selectionReturned = false;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                await showVideoPickSourceSheet(context);
                selectionReturned = true;
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('from gallery'));
    await tester.pump();

    expect(selectionReturned, isFalse);

    await tester.pumpAndSettle();
    expect(selectionReturned, isTrue);
  });
}
