import 'package:flutter/services.dart';

class NativeChannel {
  static const _channel = MethodChannel('fittrack_native');
  static Future<void> startNativeWorkout() async {
    await _channel.invokeMethod('startWorkout');
  }
  static Future<void> stopNativeWorkout() async {
    await _channel.invokeMethod('stopWorkout');
  }
}
