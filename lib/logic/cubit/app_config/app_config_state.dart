part of 'app_config_cubit.dart';

class AppConfigState extends Equatable {
  final String languageCode;
  final ThemeMode themeMode;
  // final Map<String, dynamic>? deepLinkingArguments;
  const AppConfigState({
    required this.languageCode,
    required this.themeMode,
    // this.deepLinkingArguments,
  });

  @override
  List<Object?> get props => [
        languageCode,
        themeMode,
        // deepLinkingArguments == null ? null : GlobalKey(),
      ];
}
