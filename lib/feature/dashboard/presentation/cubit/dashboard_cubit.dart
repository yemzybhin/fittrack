import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/workout_stats.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  static const _channel = MethodChannel('fittrack/sensors');

  DashboardCubit() : super(DashboardLoading()) {
    _initializeChannelListener();
    loadStats();
  }

  void loadStats() async {
    try {
      emit(DashboardLoading());
      await _channel.invokeMethod('startSensorSimulation');
    } catch (e) {
      emit(DashboardError("Failed to start background service: $e"));
    }
  }

  Future<void> refreshStats() async {
    try {
      _initializeChannelListener();
      emit(state);
    } catch (e) {
      emit(DashboardError("Refresh failed: $e"));
    }
  }

  void _initializeChannelListener() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'sensorUpdate') {
        final Map<dynamic, dynamic> data = call.arguments;
        final steps = data['steps'] ?? 0;
        final distanceKm = (steps * 0.0008).toDouble();
        final calories = (steps * 0.04).round();
        final activeMinutes = (steps / 120).round();

        final stats = WorkoutStats(
          steps: steps,
          calories: calories,
          distanceKm: distanceKm,
          activeMinutes: activeMinutes,
        );

        emit(DashboardLoaded(stats));
      }
    });
  }

  void stop() {
    _channel.invokeMethod('stopSensorSimulation');
  }

  @override
  Future<void> close() {
    stop();
    return super.close();
  }
}
