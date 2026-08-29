import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/bloc/compress_bloc.dart';
import 'package:minimo_video/features/compression/domain/compression_settings.dart';
import 'package:minimo_video/features/compression/domain/video_pick_source.dart';
import 'package:minimo_video/features/compression/presentation/compress_screen.dart';
import 'package:minimo_video/features/compression/presentation/widgets/compression_settings_view.dart';
import 'package:minimo_video/features/compression/presentation/widgets/compression_mode_switch.dart';
import 'package:minimo_video/generated/l10n.dart';
import 'package:minimo_video/theme/app_theme.dart';
import 'package:minimo_video/widgets/app_action_button.dart';
import 'package:minimo_video/widgets/minimo_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('minimo_video/videos');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('settings stay interactive while initial video imports', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1000);
    addTearDown(tester.view.resetPhysicalSize);
    final pickedVideos = Completer<List<Map<String, Object>>>();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) {
          if (call.method == 'pickVideos') return pickedVideos.future;
          return null;
        });

    await _pumpScreen(tester);
    await tester.pump();

    expect(find.byType(MinimoLoader), findsOneWidget);
    expect(find.byType(CompressionSettingsView), findsNothing);

    await _sendPickProgress(processed: 0, total: 1);
    await tester.pump();

    expect(find.byType(CompressionSettingsView), findsOneWidget);
    expect(find.text('importing videos... 0 / 1'), findsOneWidget);
    expect(find.byType(MinimoLoader), findsNWidgets(2));
    expect(find.text('0 b'), findsNothing);
    expect(
      find.text(
        'downloading from cloud storage or copying large files may take longer',
      ),
      findsOneWidget,
    );
    expect(
      find.text("try another mode — this won't make it smaller"),
      findsNothing,
    );
    await tester.ensureVisible(find.text('medium'));
    await tester.tap(find.text('medium'));
    await tester.pump();
    final modeSwitchY = tester
        .getTopLeft(find.byType(CompressionModeSwitch))
        .dy;
    final bloc = tester
        .element(find.byType(CompressionSettingsView))
        .read<CompressBloc>();
    expect(bloc.state.settings.simpleQuality, SimpleCompressionQuality.medium);
    final scrollGesture = await tester.startGesture(
      tester.getCenter(find.byType(CompressionModeSwitch)),
    );
    await scrollGesture.moveBy(const Offset(0, -80));
    await tester.pump();

    pickedVideos.complete([
      {'path': '/video.mp4', 'name': 'video.mp4', 'size': 1000},
      {'path': '/video-2.mp4', 'name': 'video-2.mp4', 'size': 1000},
    ]);
    await tester.pump();
    await tester.pump();
    await scrollGesture.cancel();

    final compress = tester.widget<AppActionButton>(
      find.byWidgetPredicate(
        (widget) => widget is AppActionButton && widget.label == 'compress',
      ),
    );
    expect(compress.loading, isFalse);
    expect(compress.onPressed, isNotNull);
    expect(
      tester.getTopLeft(find.byType(CompressionModeSwitch)).dy,
      modeSwitchY,
    );
    expect(bloc.state.settings.simpleQuality, SimpleCompressionQuality.medium);

    await tester.ensureVisible(find.text('low'));
    await tester.tap(find.text('low'));
    await tester.pump();
    expect(bloc.state.settings.simpleQuality, SimpleCompressionQuality.low);
  });

  testWidgets('failed initial import restores retry without endless loader', (
    tester,
  ) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'pickVideos') {
            throw PlatformException(code: 'pick_failed');
          }
          return null;
        });

    await _pumpScreen(tester);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('start screen'), findsOneWidget);
    expect(find.byType(MinimoLoader), findsNothing);
  });
}

Future<void> _sendPickProgress({required int processed, required int total}) {
  final data = const StandardMethodCodec().encodeMethodCall(
    MethodCall('pickProgress', {'processed': processed, 'total': total}),
  );
  return TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .handlePlatformMessage('minimo_video/videos', data, (_) {});
}

Future<void> _pumpScreen(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      initialRoute: '/compress',
      routes: {
        '/': (_) => const Scaffold(body: Text('start screen')),
        '/compress': (_) =>
            const CompressScreen(initialPickSource: VideoPickSource.gallery),
      },
    ),
  );
}
