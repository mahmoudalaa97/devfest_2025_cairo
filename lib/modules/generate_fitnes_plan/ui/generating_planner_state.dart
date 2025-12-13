sealed class GeneratingPlannerState {
  const GeneratingPlannerState();
}

class InitialState extends GeneratingPlannerState {
  const InitialState();
}

class LoadingState extends GeneratingPlannerState {
  const LoadingState();
}

class SuccessState extends GeneratingPlannerState {
  final String planner;

  const SuccessState({required this.planner});
}

class ErrorState extends GeneratingPlannerState {
  final String error;

  const ErrorState({required this.error});
}
