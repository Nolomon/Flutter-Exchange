import 'dart:convert';

class ExchangeRates {
  final String result;
  final int timeLastUpdateUnix;
  final String timeLastUpdateUtc;
  final int timeNextUpdateUnix;
  final String timeNextUpdateUtc;
  final String baseCode;
  final Map<String, double> conversionRates;

  ExchangeRates({
    required this.result,
    required this.timeLastUpdateUnix,
    required this.timeLastUpdateUtc,
    required this.timeNextUpdateUnix,
    required this.timeNextUpdateUtc,
    required this.baseCode,
    required this.conversionRates,
  });

  ExchangeRates copyWith({
    String? result,
    int? timeLastUpdateUnix,
    String? timeLastUpdateUtc,
    int? timeNextUpdateUnix,
    String? timeNextUpdateUtc,
    String? baseCode,
    Map<String, double>? conversionRates,
  }) =>
      ExchangeRates(
        result: result ?? this.result,
        timeLastUpdateUnix: timeLastUpdateUnix ?? this.timeLastUpdateUnix,
        timeLastUpdateUtc: timeLastUpdateUtc ?? this.timeLastUpdateUtc,
        timeNextUpdateUnix: timeNextUpdateUnix ?? this.timeNextUpdateUnix,
        timeNextUpdateUtc: timeNextUpdateUtc ?? this.timeNextUpdateUtc,
        baseCode: baseCode ?? this.baseCode,
        conversionRates: conversionRates ?? this.conversionRates,
      );

  factory ExchangeRates.fromRawJson(String str) =>
      ExchangeRates.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExchangeRates.fromJson(Map<String, dynamic> json) => ExchangeRates(
        result: json["result"],
        timeLastUpdateUnix: json["time_last_update_unix"],
        timeLastUpdateUtc: json["time_last_update_utc"],
        timeNextUpdateUnix: json["time_next_update_unix"],
        timeNextUpdateUtc: json["time_next_update_utc"],
        baseCode: json["base_code"],
        conversionRates: Map.from(json["conversion_rates"])
            .map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "time_last_update_unix": timeLastUpdateUnix,
        "time_last_update_utc": timeLastUpdateUtc,
        "time_next_update_unix": timeNextUpdateUnix,
        "time_next_update_utc": timeNextUpdateUtc,
        "base_code": baseCode,
        "conversion_rates": Map.from(conversionRates)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
