import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/services/review_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final supported in <bool?>[true, false, null]) {
    test(
      'native review support $supported preserves existing progress',
      () async {
        SharedPreferences.setMockInitialValues({
          'review_successful_conversions': 1,
        });
        final calls = <String>[];
        const channel = MethodChannel('rate_my_app');
        final messenger =
            TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
        messenger.setMockMethodCallHandler(channel, (call) async {
          calls.add(call.method);
          return call.method == 'isNativeDialogSupported' ? supported : null;
        });
        addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

        final prompt = await ReviewService().onSuccessfulConversions(1);
        expect(
          prompt,
          supported == true ? CompressionPrompt.review : CompressionPrompt.none,
        );
        expect(calls, [
          'isNativeDialogSupported',
          if (supported == true) 'launchNativeReviewDialog',
        ]);
        final prefs = await SharedPreferences.getInstance();
        expect(
          prefs.getInt('review_successful_conversions'),
          supported == true ? 0 : 2,
        );
        expect(
          prefs.getString('review_last_request_date'),
          supported == true ? isNotNull : isNull,
        );
        expect(
          prefs.getKeys().any((key) => key.startsWith('rateMyApp_')),
          false,
        );
      },
    );
  }

  test('rating shown today does not block an eligible photo prompt', () async {
    SharedPreferences.setMockInitialValues({
      'review_successful_conversions': 8,
      'photo_app_successful_conversions': 3,
      'review_last_request_date': '2026-11-06T08:47:02.488623',
    });
    final service = ReviewService(
      isAvailable: () async => true,
      requestReview: () async {},
      now: () => DateTime(2026, 11, 6, 9),
    );

    expect(
      await service.onSuccessfulConversions(1),
      CompressionPrompt.photoApp,
    );
  });

  test('tracks rating and photo prompts with independent cooldowns', () async {
    SharedPreferences.setMockInitialValues({});
    var requests = 0;
    var now = DateTime(2026);
    final service = ReviewService(
      isAvailable: () async => true,
      requestReview: () async => requests++,
      now: () => now,
    );

    expect(await service.onSuccessfulConversions(1), CompressionPrompt.none);
    expect(requests, 0);

    expect(await service.onSuccessfulConversions(1), CompressionPrompt.review);
    expect(requests, 1);
    var prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('review_successful_conversions'), 0);
    expect(prefs.getInt('photo_app_successful_conversions'), 2);

    now = DateTime(2026, 2);
    expect(
      await service.onSuccessfulConversions(1),
      CompressionPrompt.photoApp,
    );
    expect(requests, 1);
    prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('review_successful_conversions'), 1);
    expect(prefs.getInt('photo_app_successful_conversions'), 0);

    now = DateTime(2026, 4, 1);
    expect(await service.onSuccessfulConversions(1), CompressionPrompt.review);
    expect(requests, 2);
    prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('review_successful_conversions'), 0);
    expect(prefs.getInt('photo_app_successful_conversions'), 1);

    now = DateTime(2026, 5);
    expect(await service.onSuccessfulConversions(2), CompressionPrompt.none);
    expect(requests, 2);

    now = DateTime(2026, 5, 5);
    expect(
      await service.onSuccessfulConversions(1),
      CompressionPrompt.photoApp,
    );
    expect(requests, 2);
  });
}
