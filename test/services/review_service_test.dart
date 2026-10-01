import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/services/review_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'requests review after two successful conversions and respects cooldown',
    () async {
      SharedPreferences.setMockInitialValues({});
      var requests = 0;
      var now = DateTime(2026);
      final service = ReviewService(
        isAvailable: () async => true,
        requestReview: () async => requests++,
        now: () => now,
      );

      expect(await service.onSuccessfulConversions(1), isFalse);
      expect(requests, 0);

      expect(await service.onSuccessfulConversions(1), isTrue);
      expect(requests, 1);

      now = DateTime(2026, 2);
      expect(await service.onSuccessfulConversions(2), isFalse);
      expect(requests, 1);

      now = DateTime(2026, 4, 1);
      expect(await service.onSuccessfulConversions(2), isTrue);
      expect(requests, 2);
    },
  );
}
