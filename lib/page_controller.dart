import 'package:ai_demo/gemini_repository.dart';
import 'package:ai_demo/model/response.dart';
import 'package:ai_demo/network_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final pageControllerProvider =
    StateNotifierProvider<PageController, List<GeminiResponse>>((Ref ref) {
      return PageController(GeminiRepository(ref.read(networkProvider)));
    });

class PageController extends StateNotifier<List<GeminiResponse>> {
  PageController(this.geminiRepository) : super([]);
  final GeminiRepository geminiRepository;

  Future<void> generateStreamText(String prompt) async {
    state = [
      ...state,
      ...[
        GeminiResponse(
          candidates: [
            GeminiCandidate(
              content: GeminiContent(
                parts: [GeminiContentPart(text: prompt)],
                role: 'user',
              ),
            ),
          ],
          usageMetadata: null,
          modelVersion: '',
          responseId: '',
        ),
      ],
    ];

    final response = await geminiRepository.interractiveChat([
      GeminiContent(
        parts: [GeminiContentPart(text: prompt)],
        role: 'user',
      ),
    ]);
    if (response != null) {
      state = [...state, response];
    }
  }
}
