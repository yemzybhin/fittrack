import '../../../dashboard/domain/entities/workout_stats.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final WorkoutStats stats;

  DashboardLoaded(this.stats);
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}
