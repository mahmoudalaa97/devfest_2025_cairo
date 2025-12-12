class ApiConstants {
  ApiConstants._();
  static const String _version = 'v1beta';
  static const String _model = 'gemini-2.5-flash';
  static const String baseUrl =
      'https://generativelanguage.googleapis.com/$_version/models/$_model';

  static String get generateContent => ':generateContent';
  static String get streamGenerateContent => ':streamGenerateContent';
  static String get interractiveChat => ':generateContent';
}
