import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'workout_event.dart';
import 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  Timer? _timer;
  int _elapsed = 0;

  WorkoutBloc() : super(WorkoutState.initial()) {
    on<StartWorkout>(_onStart);
    on<PauseWorkout>(_onPause);
    on<ResumeWorkout>(_onResume);
    on<StopWorkout>(_onStop);
    on<Tick>(_onTick);
  }

  void _onStart(StartWorkout event, Emitter<WorkoutState> emit) {
    _elapsed = 0;
    emit(state.copyWith(status: WorkoutStatus.running));
    _startTimer();
  }

  void _onPause(PauseWorkout event, Emitter<WorkoutState> emit) {
    _timer?.cancel();
    emit(state.copyWith(status: WorkoutStatus.paused));
  }

  void _onResume(ResumeWorkout event, Emitter<WorkoutState> emit) {
    emit(state.copyWith(status: WorkoutStatus.running));
    _startTimer();
  }

  void _onStop(StopWorkout event, Emitter<WorkoutState> emit) {
    _timer?.cancel();
    emit(state.copyWith(status: WorkoutStatus.stopped));
  }

  void _onTick(Tick event, Emitter<WorkoutState> emit) {
    emit(state.copyWith(
      elapsedSeconds: event.elapsedSeconds,
      heartRate: event.heartRate,
    ));
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsed++;
      final randomHR = 120 + Random().nextInt(30); // Simulated HR
      add(Tick(_elapsed, randomHR));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
