import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../generated/l10n.dart';
import '../../../logic/cubit/bottom_navigation/bottom_navigation_cubit.dart';
import '../../../res/app_res.dart';
import '../../router/app_router.dart';
import '../../widgets/common/auto_keep_alive.dart';
import '../home/home_screen.dart';
import '../settings/settings.dart';

/// Created in a manner allowing possibly complex persistent bottom navigation.
class NavigationScreen extends StatefulWidget {
  static const String routeName = Navigator.defaultRouteName;

  const NavigationScreen({Key? key}) : super(key: key);
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  static const int _homePageIndex = 0;
  int _selectedPageIndex = _homePageIndex;
  late List<String> _pages;
  late PageController _pageController;
  DateTime lastBackPressTime = DateTime.now();
  late final AppRouter router;
  bool _pageViewIsAnimating = false;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  void initState() {
    router = context.read<AppRouter>();
    _pages = [
      HomeScreen.routeName,
      SettingsScreen.routeName,
    ];
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() {
    if (_pageController.page == _homePageIndex) {
      DateTime thisBackPressTime = DateTime.now();
      if (thisBackPressTime.difference(lastBackPressTime) >
          const Duration(seconds: 2)) {
        lastBackPressTime = thisBackPressTime;
        Fluttertoast.showToast(msg: S.of(context).againToExit);
        return Future.value(false);
      }
      return Future.value(true);
    } else {
      _setNavBarPage(_homePageIndex);
      _moveToPage(_homePageIndex);
      return Future.value(false);
    }
  }

  void _setNavBarPage(int destinationPageIndex) {
    if (!_pageViewIsAnimating) {
      setState(() {
        _selectedPageIndex = destinationPageIndex;
      });
      _bottomNavigationKey.currentState?.setPage(destinationPageIndex);
    }
  }

  void _moveToPage(int destinationPageIndex) {
    if (!_pageViewIsAnimating) {
      setState(() {
        _selectedPageIndex = destinationPageIndex;
      });
      _pageViewIsAnimating = true;
      _pageController
          .animateToPage(
            destinationPageIndex,
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
          )
          .then((_) => _pageViewIsAnimating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocListener<BottomNavigationCubit, BottomNavigationState>(
        listener: (context, state) {
          if (_pages.contains("/${state.routeName.split('/')[0]}")) {
            //* Navigate to the tab that is either state.routeName or a child route of it.
            _setNavBarPage(_pages.indexWhere(
                (pageRouteName) => state.routeName.startsWith(pageRouteName)));
          }
        },
        child: Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: PageView(
              allowImplicitScrolling: true,
              controller: _pageController,
              onPageChanged: (destinationPageIndex) =>
                  _setNavBarPage(destinationPageIndex),
              children: [
                //* Home
                BlocProvider.value(
                  value: router.homeCubit,
                  child: const AutoKeepAlive(child: HomeScreen()),
                ),
                //* Settings
                const AutoKeepAlive(child: SettingsScreen()),
              ],
            ),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            height: 55,
            color: Theme.of(context).colorScheme.primary,
            animationDuration: const Duration(milliseconds: 250),
            buttonBackgroundColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.transparent,
            items: [
              //* Home
              CurvedNavigationBarItem(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: SvgPicture.asset(
                    AppImages.dollarCircle,
                    height: 36,
                  ),
                ),
                label:
                    _selectedPageIndex != _pages.indexOf(HomeScreen.routeName)
                        ? S.current.converter
                        : '',
                labelStyle: const TextStyle(
                  fontSize: 12,
                  color: AppColors.white,
                ),
              ),
              //* Settings
              CurvedNavigationBarItem(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: SvgPicture.asset(
                    AppImages.settings,
                    // height: 36,
                  ),
                ),
                label: _selectedPageIndex !=
                        _pages.indexOf(SettingsScreen.routeName)
                    ? S.current.settings
                    : '',
                labelStyle: const TextStyle(
                  fontSize: 12,
                  color: AppColors.white,
                ),
              ),
            ],
            onTap: (destinationPageIndex) => _moveToPage(destinationPageIndex),
          ),
        ),
      ),
    );
  }
}
