import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  static const _successfulConversionsKey = 'review_successful_conversions';
  static const _lastReviewRequestDateKey = 'review_last_request_date';
  static const _successfulConversionsToShowReview = 2;
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

  Future<bool> onSuccessfulConversions(int count) async {
    if (count <= 0) return false;

    final prefs = await SharedPreferences.getInstance();
    final nextCount = (prefs.getInt(_successfulConversionsKey) ?? 0) + count;
    await prefs.setInt(_successfulConversionsKey, nextCount);

    if (nextCount < _successfulConversionsToShowReview) return false;
    return _requestReviewIfAllowed(prefs);
  }

  Future<bool> _requestReviewIfAllowed(SharedPreferences prefs) async {
    final lastRequestDateString = prefs.getString(_lastReviewRequestDateKey);
    if (lastRequestDateString != null) {
      final lastRequestDate = DateTime.tryParse(lastRequestDateString);
      final monthsSinceLastRequest = lastRequestDate == null
          ? _monthsBetweenReviews
          : _now().difference(lastRequestDate).inDays ~/ 30;
      if (monthsSinceLastRequest < _monthsBetweenReviews) return false;
    }

    if (!await _isAvailable()) return false;

    try {
      await _requestReview();
      await prefs.setString(
        _lastReviewRequestDateKey,
        _now().toIso8601String(),
      );
      await prefs.setInt(_successfulConversionsKey, 0);
      return true;
    } catch (_) {
      return false;
    }
  }
}
