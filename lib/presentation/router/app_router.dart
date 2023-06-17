import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exchange/data/repositories/app_config_repository.dart';
import 'package:flutter_exchange/data/repositories/home_repository.dart';
import 'package:flutter_exchange/presentation/screens/home/home_screen.dart';
import 'package:flutter_exchange/presentation/screens/splash/splash_screen.dart';
import 'package:flutter_exchange/presentation/widgets/common/auto_keep_alive.dart';
import 'package:flutter_exchange/res/app_res.dart';

import '../../data/data_providers/api_client.dart';
import '../../logic/cubit/home/home_cubit.dart';
import '../screens/navigation/navigation_screen.dart';
import '../screens/settings/settings.dart';

class AppRouter {
  final ApiClient apiClient;
  final AppConfigRepository appConfigRepository;
  late final HomeCubit homeCubit = HomeCubit(HomeRepository(apiClient));

  AppRouter({required this.apiClient, required this.appConfigRepository});

  Route generateRoute(RouteSettings settings) {
    final String routeName = settings.name ?? Navigator.defaultRouteName;

    // ignore: unused_local_variable
    final routeArguments = settings.arguments;
    log('${Constants.logWhite}Routing to $routeName');
    switch (routeName) {
      case SplashScreen.routeName:
        return _buildSplashRoute();
      case Navigator.defaultRouteName:
        return _buildNavigationRoute();
      case HomeScreen.routeName:
        return _buildHomeRoute();
      case SettingsScreen.routeName:
        return _buildSettingsRoute();
    }
    return _buildNavigationRoute();
  }

  void dispose() {
    homeCubit.close();
  }

  Route _buildSplashRoute() {
    return CupertinoPageRoute(
      builder: (_) => BlocProvider.value(
        value: homeCubit,
        child: const SplashScreen(),
      ),
    );
  }

  Route _buildNavigationRoute() {
    return CupertinoPageRoute(builder: (_) => const NavigationScreen());
  }

  Route _buildHomeRoute() => CupertinoPageRoute(
        builder: (_) => BlocProvider.value(
          value: homeCubit,
          child: const AutoKeepAlive(child: HomeScreen()),
        ),
      );

  Route _buildSettingsRoute() => CupertinoPageRoute(
        builder: (_) => const AutoKeepAlive(child: SettingsScreen()),
      );
}
