import 'package:flutter/services.dart';

import '../../generated/l10n.dart';
import '../../res/app_res.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AppConfigRepository {
  late SharedPreferences prefs;
  late ThemeMode _themeMode;


// locale section
  Locale _locale = const Locale('en');
  bool _isRTL = true;

  bool get isRTL => _isRTL;

  Locale get locale => _locale;

  void setLocale(String locale) async {
    _locale = Locale(locale);
    await S.load(Locale(locale));
    _isRTL = Bidi.isRtlLanguage(_locale.languageCode);
    await prefs.setString(Constants.languageKey, locale);
  }

  ThemeMode get themeMode => _themeMode;
  void setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await prefs.setString(Constants.themeModeKey, themeMode.name);
  }

  /// Initializes localization and any identity variables, checks firstLaunch flag.
  Future<void> initializeApp() async {
    //* Sets status bar colors
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.primary,
        statusBarColor: AppColors.primary,
      ),
    );
    prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values.firstWhere(
      (mode) => mode.name == prefs.getString(Constants.themeModeKey),
      orElse: () => ThemeMode.system,
    );
    String? languageCode = prefs.getString(Constants.languageKey);
    // DEFAULT LANGUAGE CODE
    _locale = Locale(languageCode ?? 'en');
    _isRTL = Bidi.isRtlLanguage(_locale.languageCode);
  }

}
