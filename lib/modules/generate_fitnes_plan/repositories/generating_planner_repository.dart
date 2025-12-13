import 'dart:io';

import 'package:ai_demo/model/response.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

class GeneratingPlannerRepository {
  GeneratingPlannerRepository();

  Future<GeminiResponse?> generateFitnesPlanner(
    String age,
    String height,
    String weight,
    String gender,
    String activityLevel,
    String goal,
  ) async {
    try {
      final model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.5-flash',
        systemInstruction: Content("System", [
          TextPart("Your name is Big Ramy and you are a fitness expert"),
        ]),
      );

      String promptCustom =
          """
          You are a fitness planner.
          You are given the following information:
          - Age: $age
          - Height: $height
          - Weight: $weight
          - Gender: $gender
          - Activity Level: $activityLevel
          - Goal: $goal

          check if the age or height or weight is not a number, if so, return an error message.
          You are to generate a fitness plan and diet plan for the user.
          The fitness plan should be in a markdown format.
          The diet plan should be in a markdown format.
          """;

      final response = await model.generateContent([
        Content.text(promptCustom),
      ]);
      return GeminiResponse(
        candidates: [
          GeminiCandidate(
            content: GeminiContent(
              parts: [GeminiContentPart(text: response.text ?? "")],
              role: 'model',
            ),
            finishReason: response.candidates.first.finishReason?.name,
          ),
        ],
      );
    } on SocketException catch (e) {
      debugPrint(e.toString());
      return GeminiResponse(
        candidates: [
          GeminiCandidate(
            content: GeminiContent(
              parts: [
                GeminiContentPart(
                  text: 'Ops: Check your network connection!!!',
                ),
              ],
              role: 'model',
            ),
            finishReason: 'error',
          ),
        ],
      );
    }
  }
}
