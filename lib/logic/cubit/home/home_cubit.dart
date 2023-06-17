import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exchange/data/repositories/home_repository.dart';

import '../../../data/models/exchange_rates.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;
  HomeCubit(this._homeRepository) : super(HomeInitial());

  Future<void> getExchangeRates() async {
    emit(const ExchangeRatesLoading());
    try {
      ExchangeRates exchangeRates = await _homeRepository.getExchangeRates();
      emit(ExchangeRatesLoaded(exchangeRates: exchangeRates));
    } catch (e) {
      emit(ExchangesError(exception: e));
    }
  }
}
