import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../res/app_res.dart';

class ExchangeRatesUpdateDateLabel extends StatelessWidget {
  final int lastUpdateDateUnix;
  const ExchangeRatesUpdateDateLabel(
    this.lastUpdateDateUnix, {
    super.key,
  });

  String _currentDate(DateTime dateTime) =>
      DateFormat('EEEE, d MMMM yyyy hh:mm a').format(dateTime);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Text(
        'Last Update at ${_currentDate(DateTime.fromMillisecondsSinceEpoch(lastUpdateDateUnix * 1000))}',
        style: TextStyle(
          fontSize: 12,
          color: AppColors.primarySwatch.shade50,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
