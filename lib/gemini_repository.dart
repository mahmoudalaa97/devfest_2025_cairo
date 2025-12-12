import 'package:ai_demo/model/response.dart';
import 'package:ai_demo/network_provider.dart';
import 'package:ai_demo/utlities/api_constants.dart';

class GeminiRepository {
  final NetworkProvider networkProvider;

  GeminiRepository(this.networkProvider);

  Future<GeminiResponse?> generateStreamText(String prompt) async {
    try {
      final response = await networkProvider.post(
        ApiConstants.generateContent,
        {
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        },
      );
      return GeminiResponse.fromJson(response.data);
    } on Exception catch (e) {
      print(e);
      return null;
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
      print(e);
      return null;
    }
  }
}
