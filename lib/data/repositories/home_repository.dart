import 'package:flutter_exchange/data/models/exchange_rates.dart';

import '../data_providers/api_client.dart';
import '../utils/error_handler.dart';

class HomeRepository {
  final ApiClient apiClient;

  HomeRepository(this.apiClient);

  Future<ExchangeRates> getExchangeRates() async {
    const String path = '/latest/USD';
    ExchangeRates? exchangeRates;
    try {
      exchangeRates = await apiClient.invokeApi<ExchangeRates>(path,
          requestType: ApiRequestType.get);
    } catch (e, s) {
      throw ErrorHandler<ExchangeRates>(exception: e, stackTrace: s)
          .rethrowError();
    }
    return exchangeRates!;
  }
}
