import 'dart:convert';

class GeminiResponse {
  final List<GeminiCandidate> candidates;
  final UsageMetadata? usageMetadata;
  final String? modelVersion;
  final String? responseId;

  GeminiResponse({
    required this.candidates,
    this.usageMetadata,
    this.modelVersion,
    this.responseId,
  });

  factory GeminiResponse.fromJson(Map<String, dynamic> json) {
    return GeminiResponse(
      candidates: (json['candidates'] as List)
          .map((e) => GeminiCandidate.fromJson(e))
          .toList(),
      usageMetadata: UsageMetadata.fromJson(json['usageMetadata']),
      modelVersion: json['modelVersion'],
      responseId: json['responseId'],
    );
  }
}

class GeminiCandidate {
  final GeminiContent content;
  final String? finishReason;

  GeminiCandidate({required this.content, this.finishReason});

  factory GeminiCandidate.fromJson(Map<String, dynamic> json) {
    return GeminiCandidate(
      content: GeminiContent.fromJson(json['content']),
      finishReason: json['finishReason'],
    );
  }
}

class GeminiContent {
  final List<GeminiContentPart> parts;
  final String role;

  GeminiContent({required this.parts, required this.role});

  factory GeminiContent.fromJson(Map<String, dynamic> json) {
    return GeminiContent(
      parts: (json['parts'] as List)
          .map((e) => GeminiContentPart.fromJson(e))
          .toList(),
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'parts': parts.map((e) => e.toJson()).toList(), 'role': role};
  }
}

class GeminiContentPart {
  final String text;

  GeminiContentPart({required this.text});

  factory GeminiContentPart.fromJson(Map<String, dynamic> json) {
    return GeminiContentPart(text: json['text']);
  }
  Map<String, dynamic> toJson() {
    return {'text': text};
  }
}

class UsageMetadata {
  final int promptTokenCount;
  final int totalTokenCount;
  final int? candidatesTokenCount;
  final List<TokenDetail> promptTokensDetails;
  final List<TokenDetail>? candidatesTokensDetails;

  UsageMetadata({
    required this.promptTokenCount,
    required this.totalTokenCount,
    this.candidatesTokenCount,
    required this.promptTokensDetails,
    this.candidatesTokensDetails,
  });

  factory UsageMetadata.fromJson(Map<String, dynamic> json) {
    return UsageMetadata(
      promptTokenCount: json['promptTokenCount'],
      totalTokenCount: json['totalTokenCount'],
      candidatesTokenCount: json['candidatesTokenCount'],
      promptTokensDetails: (json['promptTokensDetails'] as List)
          .map((e) => TokenDetail.fromJson(e))
          .toList(),
      candidatesTokensDetails: json['candidatesTokensDetails'] != null
          ? (json['candidatesTokensDetails'] as List)
                .map((e) => TokenDetail.fromJson(e))
                .toList()
          : null,
    );
  }
}

class TokenDetail {
  final String modality;
  final int tokenCount;

  TokenDetail({required this.modality, required this.tokenCount});

  factory TokenDetail.fromJson(Map<String, dynamic> json) {
    return TokenDetail(
      modality: json['modality'],
      tokenCount: json['tokenCount'],
    );
  }
}

// For a response array:
List<GeminiResponse> geminiResponseListFromJson(String str) =>
    List<GeminiResponse>.from(
      json.decode(str).map((x) => GeminiResponse.fromJson(x)),
    );
