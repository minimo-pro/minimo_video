import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/bloc/compress_bloc.dart';
import 'package:minimo_video/features/compression/bloc/compress_state.dart';
import 'package:minimo_video/features/compression/domain/picked_video.dart';
import 'package:minimo_video/features/compression/presentation/widgets/compression_settings_view.dart';
import 'package:minimo_video/generated/l10n.dart';
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
    expect(
      displayedValues.where((value) => value == source.size),
      hasLength(2),
    );
    expect(
      find.text("try another mode — this won't make it smaller"),
      findsNothing,
    );
  });
}

Widget _app(CompressState state, CompressBloc bloc) {
  return MaterialApp(
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
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
