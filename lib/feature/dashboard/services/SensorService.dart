import 'package:flutter/services.dart';

class SensorService {
  static const _channel = MethodChannel('fittrack/sensors');

  static void start() {
    _channel.invokeMethod('startSensorSimulation');
  }

  static void stop() {
    _channel.invokeMethod('stopSensorSimulation');
  }

  static void listen(Function(int steps, int heartRate) onData) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == "sensorUpdate") {
        final data = Map<String, dynamic>.from(call.arguments);
        final steps = data["steps"] ?? 0;
        final heartRate = data["heartRate"] ?? 0;
        onData(steps, heartRate);
      }
    });
  }
}
