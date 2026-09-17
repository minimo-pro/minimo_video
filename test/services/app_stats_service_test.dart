import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/services/app_stats_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('stores compressed video count and saved bytes locally', () async {
    SharedPreferences.setMockInitialValues({});

    await AppStatsService.recordCompressions(videoCount: 1, savedBytes: 60);
    await AppStatsService.recordCompressions(videoCount: 1, savedBytes: 25);

    final stats = await AppStatsService.load();
    expect(stats.compressedVideos, 2);
    expect(stats.savedBytes, 85);
  });
}
