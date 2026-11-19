import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/bloc/compress_bloc.dart';
import 'package:minimo_video/features/compression/bloc/compress_state.dart';
import 'package:minimo_video/features/compression/domain/picked_video.dart';
import 'package:minimo_video/features/compression/presentation/widgets/compression_settings_view.dart';
import 'package:minimo_video/features/compression/presentation/widgets/selected_videos_summary.dart';
import 'package:minimo_video/generated/l10n.dart';
import 'package:minimo_video/widgets/minimo_loader.dart';
import 'package:minimo_video/widgets/rolling_counter_text.dart';

void main() {
  testWidgets('does not show an optimistic size before the first estimate', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1000);
    addTearDown(tester.view.resetPhysicalSize);
    const source = PickedVideo(
      path: '/video.mp4',
      name: 'video.mp4',
      size: 1000,
    );
    final state = CompressState.initial(const [source]);
    final bloc = CompressBloc();
    addTearDown(bloc.close);

    await tester.pumpWidget(_app(state, bloc));

    final displayedValues = tester
        .widgetList<RollingCounterText>(find.byType(RollingCounterText))
        .map((widget) => widget.value);
    expect(displayedValues, isEmpty);
    expect(
      find.text("try another mode — this won't make it smaller"),
      findsNothing,
    );
    expect(
      find.descendant(
        of: find.byType(SelectedVideosSummary),
        matching: find.byType(MinimoLoader),
      ),
      findsNothing,
    );
  });

  testWidgets('shows familiar quality levels without trust copy', (
    tester,
  ) async {
    final bloc = CompressBloc();
    addTearDown(bloc.close);

    await tester.pumpWidget(_app(CompressState.initial(const []), bloc));

    expect(find.text('quality'), findsOneWidget);
    expect(find.text('high'), findsOneWidget);
    expect(find.text('medium'), findsOneWidget);
    expect(find.text('low'), findsOneWidget);
    expect(find.text('on device • open source'), findsNothing);
    expect(
      find.text('keeps the original if it saves less than 10%'),
      findsNothing,
    );
  });

  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    testWidgets('shows the HDR conversion hint on $platform', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      addTearDown(tester.view.resetPhysicalSize);
      const source = PickedVideo(
        path: '/video.mp4',
        name: 'video.mp4',
        size: 1000,
      );
      final state = CompressState.initial(const [source]).copyWith(
        hdrVideoPaths: {'/video.mp4'},
        estimatedSize: 800,
        isEstimating: false,
      );
      final bloc = CompressBloc();
      addTearDown(bloc.close);

      await tester.pumpWidget(_app(state, bloc, platform: platform));

      expect(find.byKey(const ValueKey('hdr-conversion-hint')), findsOneWidget);
      expect(find.text('HDR'), findsOneWidget);
      expect(
        find.text(
          platform == TargetPlatform.iOS
              ? 'HDR videos use HEVC to keep HDR when supported. Otherwise, they convert to SDR.'
              : 'HDR video will be converted to SDR — colours may change slightly',
        ),
        findsOneWidget,
      );
    });
  }
}

Widget _app(
  CompressState state,
  CompressBloc bloc, {
  TargetPlatform? platform,
}) {
  return MaterialApp(
    theme: ThemeData(platform: platform),
    localizationsDelegates: const [
      S.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: BlocProvider.value(
      value: bloc,
      child: Scaffold(
        body: CompressionSettingsView(state: state, onAddVideos: null),
      ),
    ),
  );
}
