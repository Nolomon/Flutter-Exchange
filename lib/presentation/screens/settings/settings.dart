import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exchange/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_exchange/logic/cubit/app_config/app_config_cubit.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final AppConfigCubit _appConfigCubit;

  @override
  void initState() {
    _appConfigCubit = context.read<AppConfigCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.current.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  S.current.theme,
                  style: const TextStyle(fontSize: 18),
                ),
                SizedBox(width: 20.w),
                Switch.adaptive(
                  value: _appConfigCubit.isForcedDarkMode,
                  trackColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Theme.of(context).disabledColor;
                    }
                    return Theme.of(context).colorScheme.primaryContainer;
                  }),
                  trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Theme.of(context).disabledColor;
                    }
                    return Theme.of(context).colorScheme.primary;
                  }),
                  thumbColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Theme.of(context).disabledColor;
                    }
                    return Theme.of(context).colorScheme.onPrimary;
                  }),
                  thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return const Icon(Icons.dark_mode);
                    } else if (states.contains(MaterialState.disabled)) {
                      return const Icon(Icons.hdr_auto);
                    }
                    return Icon(
                      Icons.light_mode,
                      color: Theme.of(context).colorScheme.primary,
                    );
                  }),
                  onChanged: _appConfigCubit.themeMode == ThemeMode.system
                      ? null
                      : (mode) => setState(() {
                            _appConfigCubit.themeMode =
                                _appConfigCubit.isForcedDarkMode
                                    ? ThemeMode.light
                                    : ThemeMode.dark;
                          }),
                ),
                const Spacer(),
                Checkbox.adaptive(
                  value: _appConfigCubit.themeMode != ThemeMode.system,
                  onChanged: (enabled) {
                    setState(() {
                      if (enabled ?? false) {
                        _appConfigCubit.themeMode =
                            Theme.of(context).brightness == Brightness.light
                                ? ThemeMode.light
                                : ThemeMode.dark;
                      } else {
                        _appConfigCubit.themeMode = ThemeMode.system;
                      }
                    });
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
