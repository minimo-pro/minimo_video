import 'package:shared_preferences/shared_preferences.dart';

abstract final class FirstLaunchService {
  static const _onboardingCompletedKey = 'onboarding_completed';

  static Future<bool> shouldShowOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    return !(preferences.getBool(_onboardingCompletedKey) ?? false);
  }

  static Future<void> completeOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_onboardingCompletedKey, true);
  }
}
