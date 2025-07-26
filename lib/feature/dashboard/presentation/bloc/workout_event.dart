abstract class WorkoutEvent {}

class StartWorkout extends WorkoutEvent {}

class PauseWorkout extends WorkoutEvent {}

class ResumeWorkout extends WorkoutEvent {}

class StopWorkout extends WorkoutEvent {}

class Tick extends WorkoutEvent {
  final int elapsedSeconds;
  final int heartRate;

  Tick(this.elapsedSeconds, this.heartRate);
}
