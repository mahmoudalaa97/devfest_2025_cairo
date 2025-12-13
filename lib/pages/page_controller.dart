import 'package:ai_demo/gemini_repository.dart';
import 'package:ai_demo/pages/generating_planner_state.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final pageControllerProvider =
    StateNotifierProvider<PageController, GeneratingPlannerState>((Ref ref) {
      return PageController(FitnessPlannerRepository());
    });

class PageController extends StateNotifier<GeneratingPlannerState> {
  PageController(this.fitnessPlannerRepository) : super(InitialState());
  final FitnessPlannerRepository fitnessPlannerRepository;

  Future<void> generateFitnessPlanner(
    String age,
    String height,
    String weight,
    String gender,
    String activityLevel,
    String goal,
  ) async {
    state = LoadingState();
    final response = await fitnessPlannerRepository.generateFitnessPlanner(
      age,
      height,
      weight,
      gender,
      activityLevel,
      goal,
    );

    if (response != null) {
      state = SuccessState(
        planner: response.candidates.first.content.parts.first.text,
      );
    } else {
      state = ErrorState(error: "Failed to generate fitness planner");
    }
  }
}
