import 'package:wakelock_plus/wakelock_plus.dart';

class ScreenAwakeService {
  static ScreenAwakeService instance = ScreenAwakeService();

  Future<void> setEnabled(bool enabled) async {
    try {
      await WakelockPlus.toggle(enable: enabled);
    } catch (_) {}
  }
}
