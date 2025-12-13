import 'package:ai_demo/modules/generate_fitnes_plan/repositories/generating_planner_repository.dart';
import 'package:ai_demo/modules/generate_fitnes_plan/ui/generating_planner_state.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final generatingPlannerController =
    StateNotifierProvider<GeneratingPlannerController, GeneratingPlannerState>((
      Ref ref,
    ) {
      return GeneratingPlannerController(GeneratingPlannerRepository());
    });

class GeneratingPlannerController
    extends StateNotifier<GeneratingPlannerState> {
  GeneratingPlannerController(this.generatingPlannerRepository)
    : super(InitialState());
  final GeneratingPlannerRepository generatingPlannerRepository;

  Future<void> generateFitnesPlanner(
    String age,
    String height,
    String weight,
    String gender,
    String activityLevel,
    String goal,
  ) async {
    state = LoadingState();
    final response = await generatingPlannerRepository.generateFitnesPlanner(
      age,
      height,
      weight,
      gender,
      activityLevel,
      goal,
    );

    if (response != null) {
      state = SuccessState(
        planner: response,
      );
    } else {
      state = ErrorState(error: "Failed to generate fitness planner");
    }
  }
}
