import 'package:flutter/services.dart';

enum ThermalState { unknown, nominal, fair, serious, critical }

abstract final class ThermalService {
  static const _channel = MethodChannel('minimo_video/thermal');

  static Future<ThermalState> currentState() async {
    try {
      final value = await _channel.invokeMethod<String>('currentState');
      return switch (value) {
        'nominal' => ThermalState.nominal,
        'fair' => ThermalState.fair,
        'serious' => ThermalState.serious,
        'critical' => ThermalState.critical,
        _ => ThermalState.unknown,
      };
    } on PlatformException {
      return ThermalState.unknown;
    } on MissingPluginException {
      return ThermalState.unknown;
    }
  }

  static bool shouldWarn(ThermalState state) {
    return state == ThermalState.serious || state == ThermalState.critical;
  }
}
