import 'dart:io';

import 'package:ai_demo/model/response.dart';
import 'package:ai_demo/network_provider.dart';
import 'package:ai_demo/utlities/api_constants.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

class GeminiRepository {
  final NetworkProvider networkProvider;

  GeminiRepository(this.networkProvider);

  Future<GeminiResponse?> generateContent(String prompt) async {
    try {
      final model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.5-flash',
        systemInstruction: Content("System", [TextPart("Your name is jood")]),
      );

      String promptCustom =
          "Instraction for this model your name is jood and this is the user prompt message:$prompt";

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

  Future<GeminiResponse?> interractiveChat(List<GeminiContent> parts) async {
    try {
      final response = await networkProvider.post(
        ApiConstants.interractiveChat,
        {"contents": parts.map((e) => e.toJson()).toList()},
      );
      return GeminiResponse.fromJson(response.data);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
