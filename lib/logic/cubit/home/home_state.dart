part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class ExchangeRatesLoading extends HomeState {
  const ExchangeRatesLoading();
}

class ExchangeRatesLoaded extends HomeState {
  final ExchangeRates exchangeRates;
  const ExchangeRatesLoaded({required this.exchangeRates});
}

class ExchangesError extends HomeState {
  final Object exception;
  const ExchangesError({required this.exception});
}
