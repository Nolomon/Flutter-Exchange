import 'dart:developer';

import 'package:flutter_exchange/data/models/exchange_rates.dart';

import 'errors.dart';
import 'package:flutter/services.dart';

class ApiDeserializer<R> {
  final String rawJson;

  ApiDeserializer({required this.rawJson});

  ///Tries to parse `rawJson` into the model object specified by generic `<R>` type.
  ///
  ///Throws a `ParsingException` in case of any parsing errors.
  dynamic deserialize() {
    try {
      switch (R) {
        case String:
          return rawJson;
        case ExchangeRates:
          return ExchangeRates.fromRawJson(rawJson);
        default:
          throw PlatformException(code: '', message: 'can not find response');
      }
    } on Error catch (e, s) {
      log(e.toString());
      log(s.toString());
      throw ParsingException(
        message: e.toString(),
        stack: s.toString(),
      );
    }
  }
}
