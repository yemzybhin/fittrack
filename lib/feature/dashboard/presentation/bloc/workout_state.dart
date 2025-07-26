enum WorkoutStatus { initial, running, paused, stopped }

class WorkoutState {
  final WorkoutStatus status;
  final int elapsedSeconds;
  final int heartRate;

  WorkoutState({
    required this.status,
    required this.elapsedSeconds,
    required this.heartRate,
  });

  factory WorkoutState.initial() => WorkoutState(
        status: WorkoutStatus.initial,
        elapsedSeconds: 0,
        heartRate: 0,
      );

  WorkoutState copyWith({
    WorkoutStatus? status,
    int? elapsedSeconds,
    int? heartRate,
  }) {
    return WorkoutState(
      status: status ?? this.status,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      heartRate: heartRate ?? this.heartRate,
    );
  }
}
