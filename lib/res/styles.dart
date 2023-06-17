part of app_res;

class Styles {
  Styles._();

  static const String _fontFamily = 'Roboto';

  static String get fontFamily => _fontFamily;

  static ThemeData get theme => ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          shadow: Colors.black26,
        ),
        useMaterial3: true,
      ).copyWith(
        inputDecorationTheme: inputDecorationTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
        ),
      );

  static ThemeData get darkTheme => ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        useMaterial3: true,
      ).copyWith(
        inputDecorationTheme: inputDecorationTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
        ),
      );

  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        isDense: true,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        counterStyle: counterStyle,
      );

  static TextStyle get counterStyle =>
      TextStyle(color: AppColors.lightGrey, fontSize: 12);

  /// Character counter for text fields
  static Widget counter(
    BuildContext context, {
    required int currentLength,
    required int? maxLength,
    required bool isFocused,
  }) {
    return Text(
      '$currentLength/$maxLength',
      style: counterStyle,
      semanticsLabel: 'character count',
    );
  }
}
