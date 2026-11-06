import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CompressionPrompt { none, review, photoApp }

class ReviewService {
  static const _successfulConversionsKey = 'review_successful_conversions';
  static const _photoConversionsKey = 'photo_app_successful_conversions';
  static const _lastReviewRequestDateKey = 'review_last_request_date';
  static const _lastPhotoPromptDateKey = 'photo_app_last_prompt_date';
  static const _successfulConversionsToShowReview = 2;
  static const _successfulConversionsToShowPhotoApp = 3;
  static const _monthsBetweenReviews = 3;

  static final instance = ReviewService();

  final Future<bool> Function() _isAvailable;
  final Future<void> Function() _requestReview;
  final DateTime Function() _now;

  ReviewService({
    Future<bool> Function()? isAvailable,
    Future<void> Function()? requestReview,
    DateTime Function()? now,
  }) : _isAvailable = isAvailable ?? InAppReview.instance.isAvailable,
       _requestReview = requestReview ?? InAppReview.instance.requestReview,
       _now = now ?? DateTime.now;

  Future<CompressionPrompt> onSuccessfulConversions(int count) async {
    if (count <= 0) return CompressionPrompt.none;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _successfulConversionsKey,
      (prefs.getInt(_successfulConversionsKey) ?? 0) + count,
    );
    await prefs.setInt(
      _photoConversionsKey,
      (prefs.getInt(_photoConversionsKey) ?? 0) + count,
    );
    return _showPromptIfAllowed(prefs);
  }

  Future<CompressionPrompt> _showPromptIfAllowed(
    SharedPreferences prefs,
  ) async {
    final lastReview = DateTime.tryParse(
      prefs.getString(_lastReviewRequestDateKey) ?? '',
    );
    final lastPhoto = DateTime.tryParse(
      prefs.getString(_lastPhotoPromptDateKey) ?? '',
    );
    if (lastReview != null &&
        (lastPhoto == null || lastReview.isAfter(lastPhoto)) &&
        (prefs.getInt(_photoConversionsKey) ?? 0) >=
            _successfulConversionsToShowPhotoApp &&
        (lastPhoto == null ||
            _now().difference(lastPhoto).inDays ~/ 30 >=
                _monthsBetweenReviews)) {
      await prefs.setString(_lastPhotoPromptDateKey, _now().toIso8601String());
      await prefs.setInt(_photoConversionsKey, 0);
      return CompressionPrompt.photoApp;
    }

    if ((prefs.getInt(_successfulConversionsKey) ?? 0) <
            _successfulConversionsToShowReview ||
        (lastReview != null &&
            _now().difference(lastReview).inDays ~/ 30 <
                _monthsBetweenReviews)) {
      return CompressionPrompt.none;
    }
    if (!await _isAvailable()) return CompressionPrompt.none;

    try {
      await _requestReview();
      await prefs.setString(
        _lastReviewRequestDateKey,
        _now().toIso8601String(),
      );
      await prefs.setInt(_successfulConversionsKey, 0);
      return CompressionPrompt.review;
    } catch (_) {
      return CompressionPrompt.none;
    }
  }
}
