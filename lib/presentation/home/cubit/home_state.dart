import 'package:currency_exchange/domain/entity/currency.dart';
import 'package:currency_exchange/domain/entity/currency_rate.dart';
import 'package:currency_exchange/presentation/utils/enums.dart';
import 'package:equatable/equatable.dart';

class HomeState with EquatableMixin {
  final PageStatus status;
  final List<Currency> allCurrencies;
  final Currency fromCurrency;
  final Currency toCurrency;
  final List<CurrencyRate> rates;
  final String fromValue;
  final String toValue;
  final String errorMessage;

  const HomeState({
    this.allCurrencies = const [],
    this.fromCurrency = Currency.usd,
    this.toCurrency = Currency.rub,
    this.rates = const [],
    this.fromValue = '1',
    this.toValue = '0',
    this.status = PageStatus.loaded,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [
        status,
        allCurrencies,
        fromCurrency,
        toCurrency,
        rates,
        fromValue,
        toValue,
        errorMessage
      ];

  CurrencyRate getRateByCode(String code) {
    return rates.firstWhere(
      (element) => element.codeFrom.toLowerCase() == code.toLowerCase(),
    );
  }

  HomeState copyWith({
    PageStatus? status,
    List<Currency>? allCurrencies,
    Currency? fromCurrency,
    Currency? toCurrency,
    List<CurrencyRate>? rates,
    String? fromValue,
    String? toValue,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      allCurrencies: allCurrencies ?? this.allCurrencies,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      rates: rates ?? this.rates,
      fromValue: fromValue ?? this.fromValue,
      toValue: toValue ?? this.toValue,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
