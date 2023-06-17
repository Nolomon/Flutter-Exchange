import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_exchange/res/app_res.dart';

import '../../../../utils/currency_flags.dart';

class ExchangeConverter extends StatefulWidget {
  final bool resultOnly;
  final TextEditingController controller;
  final String fromCurrency;
  final String toCurrency;
  final Map<String, double> conversionRates;
  final Function(double? amount, String currency)? onChanged;
  const ExchangeConverter({
    super.key,
    this.resultOnly = false,
    required this.controller,
    required this.conversionRates,
    required this.fromCurrency,
    required this.toCurrency,
    this.onChanged,
  });

  @override
  State<ExchangeConverter> createState() => _ExchangeConverterState();
}

class _ExchangeConverterState extends State<ExchangeConverter> {
  late String _exchangeFrom;

  @override
  void initState() {
    _exchangeFrom = widget.fromCurrency;
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    // Update state variable _exchangeFrom if parent widget passed a different fromCurrency.
    if (oldWidget.fromCurrency != widget.fromCurrency) {
      _exchangeFrom = widget.fromCurrency;
    }
    // If toCurrency changed, do the conversion and call onChanged
    if (!widget.resultOnly && oldWidget.toCurrency != widget.toCurrency) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _convertAndUpdate(widget.controller.text);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _convertAndUpdate(String text) {
    final double? sanitatedValue = double.tryParse(text);
    widget.onChanged?.call(
      sanitatedValue == null ? null : _convert(sanitatedValue),
      _exchangeFrom,
    );
  }

  double _convert(double amount) {
    return (amount / widget.conversionRates[_exchangeFrom]!) *
        widget.conversionRates[widget.toCurrency]!;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: Styles.inputDecorationTheme.copyWith(
          border: const UnderlineInputBorder(),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            //* Flag
            Text(
              flagOfCurrencyCountry(_exchangeFrom),
              style: const TextStyle(fontSize: 24),
            ),
            SizedBox(width: 17.w),
            //* Currency
            Text(_exchangeFrom),
            //* Currencies Dropdown
            PopupMenuButton<String>(
              initialValue: _exchangeFrom,
              icon: SvgPicture.asset(
                AppImages.arrowDown,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.tertiary
                    : null,
              ),
              onSelected: (exchange) {
                setState(() {
                  _exchangeFrom = exchange;
                  _convertAndUpdate(widget.controller.text);
                });
              },
              itemBuilder: (BuildContext context) {
                return widget.conversionRates.keys
                    .map((currency) => PopupMenuItem(
                          value: currency,
                          child: Row(
                            children: [
                              Text(
                                flagOfCurrencyCountry(currency),
                                style: const TextStyle(fontSize: 21),
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                currency,
                                overflow: TextOverflow.fade,
                              )
                            ],
                          ),
                        ))
                    .toList();
              },
            ),
            //* Amount Input
            Expanded(
              flex: 10,
              child: TextField(
                readOnly: widget.resultOnly,
                controller: widget.controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: widget.resultOnly
                      ? UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5),
                        )
                      : OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Theme.of(context).colorScheme.tertiary
                                    : Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                ),
                onChanged: _convertAndUpdate,
              ),
            )
          ],
        ),
      ),
    );
  }
}
