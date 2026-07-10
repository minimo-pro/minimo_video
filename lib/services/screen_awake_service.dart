import 'package:wakelock_plus/wakelock_plus.dart';

class ScreenAwakeService {
  static final instance = ScreenAwakeService();

  Future<void> setEnabled(bool enabled) {
    return WakelockPlus.toggle(enable: enabled);
  }
}
