import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_exchange/presentation/screens/navigation/navigation_screen.dart';
import 'package:flutter_exchange/res/app_res.dart';

import '../../../logic/cubit/home/home_cubit.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final HomeCubit _homeCubit;
  @override
  void initState() {
    _homeCubit = context.read<HomeCubit>();
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      Future.wait([
        _homeCubit.getExchangeRates(),
      ]).then((_) =>
          Navigator.pushReplacementNamed(context, NavigationScreen.routeName));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.appGradientColor1,
                  Color.alphaBlend(
                    Colors.black.withAlpha(0x66),
                    AppColors.appGradientColor2,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(AppImages.launcherIcon),
                Image.asset(AppImages.logo),
              ],
            ),
          ),
          Positioned(
            bottom: 0.10.sh,
            left: 0.20.sw,
            right: 0.20.sw,
            child: FutureBuilder(
              future: Future.delayed(const Duration(seconds: 5)),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      return const LinearProgressIndicator();
                    },
                  );
                }
                return const SizedBox(height: 5.0);
              },
            ),
          ),
        ],
      ),
    );
  }
}
