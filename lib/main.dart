import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'config/api_config.dart';
import 'data/data_providers/api_client.dart';
import 'data/repositories/app_config_repository.dart';
import 'generated/l10n.dart';
import 'logic/cubit/app_config/app_config_cubit.dart';
import 'logic/cubit/bottom_navigation/bottom_navigation_cubit.dart';
import 'presentation/router/app_router.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/widgets/common/controlled_focus.dart';
import 'res/app_res.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = AppHttpOverrides();
  final AppConfigRepository appConfigRepository = AppConfigRepository();
  await appConfigRepository.initializeApp();
  ApiClient apiClient = ApiClient(
    baseURL: ApiConfig.baseURL,
    languageCode: appConfigRepository.locale.languageCode,
  );

  runApp(
    App(
      appConfigRepository: appConfigRepository,
      apiClient: apiClient,
    ),
  );
}

class App extends StatefulWidget {
  final AppConfigRepository appConfigRepository;
  final ApiClient apiClient;

  const App(
      {Key? key, required this.apiClient, required this.appConfigRepository})
      : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final StreamSubscription _sub;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void dispose() {
    //* Always dispose router when closing;
    //* Some blocs are manually initialized and are kept alive to share between multiple routes.
    context.read<AppRouter>().dispose();
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AppRouter(
            apiClient: widget.apiClient,
            appConfigRepository: widget.appConfigRepository,
          ),
        ),
        RepositoryProvider.value(
          value: widget.appConfigRepository,
        ),
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AppConfigCubit(widget.appConfigRepository),
            ),
            BlocProvider(
              create: (context) => BottomNavigationCubit(),
            )
          ],
          child: BlocConsumer<AppConfigCubit, AppConfigState>(
            listenWhen: (prev, curr) => prev.languageCode != curr.languageCode,
            listener: (appConfigContext, appConfigState) {
              widget.apiClient.setLanguageCode(appConfigState.languageCode);
            },
            builder: (appConfigContext, appConfigState) {
              return ControlledFocus(
                child: ScreenUtilInit(
                  designSize: const Size(414, 896),
                  minTextAdapt: true,
                  splitScreenMode: true,
                  builder: (context, _) {
                    return MaterialApp(
                      onGenerateTitle: (_) => S.current.appName,
                      themeMode: appConfigState.themeMode,
                      theme: Styles.theme,
                      darkTheme: Styles.darkTheme,
                      debugShowCheckedModeBanner: false,
                      locale: widget.appConfigRepository.locale,
                      localizationsDelegates: const [
                        S.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                        DefaultCupertinoLocalizations.delegate,
                      ],
                      supportedLocales: S.delegate.supportedLocales,
                      onGenerateRoute: (routeSettings) {
                        // Post ApiClient initialization goes here
                        return context
                            .read<AppRouter>()
                            .generateRoute(routeSettings);
                      },
                      navigatorKey: navigatorKey,
                      initialRoute: SplashScreen.routeName,
                      onGenerateInitialRoutes: (String initialRouteName) {
                        return [
                          context.read<AppRouter>().generateRoute(
                                RouteSettings(
                                  name: initialRouteName,
                                ),
                              ),
                        ];
                      },
                    );
                  },
                ),
              );
            },
          )),
    );
  }
}

class AppHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
