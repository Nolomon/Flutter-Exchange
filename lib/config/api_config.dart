class ApiConfig {
  // API key called exchange42 for obfuscation
  static const String apiKey = String.fromEnvironment('exchange42');
  static const String baseURL = 'https://v6.exchangerate-api.com/v6/$apiKey';
}
