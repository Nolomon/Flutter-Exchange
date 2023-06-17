import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/app_config_repository.dart';
import 'package:equatable/equatable.dart';

part 'app_config_state.dart';

class AppConfigCubit extends Cubit<AppConfigState> {
  final AppConfigRepository _appConfigRepository;
  AppConfigCubit(this._appConfigRepository)
      : super(
          AppConfigState(
            languageCode: _appConfigRepository.locale.languageCode,
            themeMode: _appConfigRepository.themeMode,
          ),
        );

  Future<void> clearAppData({bool keepLanguage = true}) async {
    final locale = _appConfigRepository.locale;
    await _appConfigRepository.prefs.clear();
    if (keepLanguage) {
      _appConfigRepository.setLocale(locale.languageCode);
    }
  }

  set locale(String languageCode) {
    _appConfigRepository.setLocale(languageCode);
    emit(
      AppConfigState(
        languageCode: languageCode,
        themeMode: _appConfigRepository.themeMode,
      ),
    );
  }

  set themeMode(ThemeMode themeMode) {
    _appConfigRepository.setThemeMode(themeMode);
    emit(
      AppConfigState(
        languageCode: _appConfigRepository.locale.languageCode,
        themeMode: themeMode,
      ),
    );
  }

  ThemeMode get themeMode => _appConfigRepository.themeMode;

  bool get isForcedDarkMode => _appConfigRepository.themeMode == ThemeMode.dark;


}
