import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../data/utils/error_handler.dart';
import '../../../logic/cubit/home/home_cubit.dart';
import '../../widgets/background_column.dart';
import '../../widgets/common/common.dart';
import 'widgets/exchange_rates_update_date_label.dart';
import 'widgets/exchange_converter.dart';
import 'widgets/swap_button.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();

  bool _canSwap = false;
  late final HomeCubit _homeCubit;
  String? _firstCurrency, _secondCurrency;

  @override
  void initState() {
    _homeCubit = context.read<HomeCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: BackgroundColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //* Update Date
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is ExchangeRatesLoaded) {
                  return ExchangeRatesUpdateDateLabel(
                    state.exchangeRates.timeLastUpdateUnix,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            SizedBox(height: 130.h),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is ExchangesError) {
                  return ErrorHandler(exception: state.exception)
                      .buildErrorWidget(
                          context: context,
                          retryCallback: () => _homeCubit.getExchangeRates());
                } else if (state is ExchangeRatesLoading) {
                  return const CenteredCircularProgressIndicator();
                } else if (state is ExchangeRatesLoaded) {
                  return Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //* First Converter
                          ExchangeConverter(
                            key: const ValueKey('firstConverter'),
                            controller: _firstController,
                            conversionRates:
                                state.exchangeRates.conversionRates,
                            fromCurrency: _firstCurrency ??
                                state.exchangeRates.conversionRates.keys.first,
                            toCurrency: _secondCurrency ??
                                state.exchangeRates.conversionRates.keys.first,
                            onChanged: (converted, exchangeFrom) {
                              setState(() {
                                _firstCurrency = exchangeFrom;
                                if (converted != null) {
                                  _secondController.text =
                                      NumberFormat('#.0###').format(converted);
                                }
                              });
                            },
                          )
                              .animate(
                                target: _canSwap ? 1 : 0,
                              )
                              .moveY(
                                  end: 20,
                                  curve: Curves.easeOut,
                                  duration: 250.ms)
                              .then()
                              .moveY(end: -20),
                          SizedBox(height: 31.h),
                          //* Swap Button
                          Center(
                            child: SwapButton(
                              onPressed: (canSwap) {
                                setState(() {
                                  _canSwap = canSwap;
                                  final String? tempCurrency = _firstCurrency;
                                  _firstCurrency = _secondCurrency;
                                  _secondCurrency = tempCurrency;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 31.h),
                          //* Second Converter
                          ExchangeConverter(
                            key: const ValueKey('secondConverter'),
                            resultOnly: true,
                            controller: _secondController,
                            conversionRates:
                                state.exchangeRates.conversionRates,
                            fromCurrency: _secondCurrency ??
                                state.exchangeRates.conversionRates.keys.first,
                            toCurrency: _firstCurrency ??
                                state.exchangeRates.conversionRates.keys.first,
                            onChanged: (converted, exchangeFrom) {
                              setState(() => _secondCurrency = exchangeFrom);
                            },
                          )
                              .animate(
                                target: _canSwap ? 1 : 0,
                              )
                              .moveY(
                                  end: -20,
                                  curve: Curves.easeOut,
                                  duration: 250.ms)
                              .then()
                              .moveY(end: 20),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
