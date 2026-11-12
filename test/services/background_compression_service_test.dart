import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/services/background_compression_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('minimo_video/background_compression');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final calls = <MethodCall>[];

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    calls.clear();
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return call.method == 'start' ? true : null;
    });
  });
  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    channel.setMethodCallHandler(null);
    debugDefaultTargetPlatformOverride = null;
  });

  Future<void> cancel(String token) async {
    await messenger.handlePlatformMessage(
      channel.name,
      const StandardMethodCodec().encodeMethodCall(MethodCall('cancel', token)),
      (_) {},
    );
  }

  test(
    'rejects stale cancellation and ends the matching runtime grant',
    () async {
      final service = BackgroundCompressionService();
      var cancellations = 0;
      expect(await service.start(onCancel: () => cancellations++), isTrue);
      final token = (calls.single.arguments as Map)['token'] as String;
      await cancel('old-task');
      expect(cancellations, 0);
      await cancel(token);
      expect(cancellations, 1);
      await service.finish(success: false);
      expect(calls.last.method, 'finish');
      expect(calls.last.arguments, {'token': token, 'success': false});
      await cancel(token);
      expect(cancellations, 1);
    },
  );

  test('coalesces progress without dropping file transitions', () async {
    final service = BackgroundCompressionService();
    await service.start(onCancel: () {});
    await service.update(0.25, 1, 2);
    await service.update(0.25001, 1, 2);
    await service.update(0.25, 2, 2);
    expect(calls.where((call) => call.method == 'update'), hasLength(2));
    await service.finish(success: true);
  });

  test('denied admission leaves no progress or completion calls', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      throw PlatformException(code: 'unavailable');
    });
    final service = BackgroundCompressionService();
    expect(await service.start(onCancel: () {}), isFalse);
    await service.update(0.5, 1, 1);
    await service.finish(success: false);
    expect(calls.map((call) => call.method), ['start']);
  });

  test(
    'Android leaves background execution to the compressor plugin',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final service = BackgroundCompressionService();
      expect(await service.start(onCancel: () {}), isFalse);
      await service.finish(success: false);
      expect(calls, isEmpty);
    },
  );
}
