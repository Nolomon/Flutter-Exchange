part of app_res;

///Contains const/final values that are used across the code base.
class Constants {
  Constants._();

  //* Keys
  static const String tokenKey = 'token';
  static const String languageKey = 'languageKey';
  static const String themeModeKey = "themeModeKey";

  //* ANSI colors for log messages
  static const String logReset = '\x1B[0m';
  static const String logBlack = '\x1B[30m';
  static const String logRed = '\x1B[31m';
  static const String logGreen = '\x1B[32m';
  static const String logYellow = '\x1B[33m';
  static const String logBlue = '\x1B[34m';
  static const String logPurple = '\x1B[35m';
  static const String logCyan = '\x1B[36m';
  static const String logWhite = '\x1B[37m';
}
