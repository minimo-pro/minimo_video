import 'package:shared_preferences/shared_preferences.dart';

class AppStats {
  final int compressedVideos;
  final int savedBytes;

  const AppStats({required this.compressedVideos, required this.savedBytes});
}

abstract final class AppStatsService {
  static const _compressedVideosKey = 'stats_compressed_videos';
  static const _savedBytesKey = 'stats_saved_bytes';

  static Future<AppStats> load() async {
    final preferences = await SharedPreferences.getInstance();
    return AppStats(
      compressedVideos: preferences.getInt(_compressedVideosKey) ?? 0,
      savedBytes: preferences.getInt(_savedBytesKey) ?? 0,
    );
  }

  static Future<void> recordCompressions({
    required int videoCount,
    required int savedBytes,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.wait([
      preferences.setInt(
        _compressedVideosKey,
        (preferences.getInt(_compressedVideosKey) ?? 0) + videoCount,
      ),
      preferences.setInt(
        _savedBytesKey,
        (preferences.getInt(_savedBytesKey) ?? 0) +
            (savedBytes < 0 ? 0 : savedBytes),
      ),
    ]);
  }
}
