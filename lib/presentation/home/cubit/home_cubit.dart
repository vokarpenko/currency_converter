import 'package:currency_exchange/domain/entity/currency.dart';
import 'package:currency_exchange/domain/entity/currency_rate.dart';
import 'package:currency_exchange/domain/entity/exceptions/app_exception.dart';
import 'package:currency_exchange/domain/usecase/currencies_use_cases.dart';
import 'package:currency_exchange/domain/usecase/rates_use_cases.dart';
import 'package:currency_exchange/presentation/home/cubit/home_state.dart';
import 'package:currency_exchange/presentation/utils/enums.dart';
import 'package:currency_exchange/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConvertType { from, to }

class HomeCubit extends Cubit<HomeState> {
  final TextEditingController controllerFrom = TextEditingController(text: '1');
  final TextEditingController controllerTo = TextEditingController();
  static const String _defaultErrorMessage =
      'An unexpected error occurred, we are already working on it';

  HomeCubit() : super(const HomeState()) {
    _init();
  }

  Future<void> _init() async {
    final List<Currency> allCurrencies = await getIt.get<GetAllCurrencies>()();
    final from = getIt.get<GetCurrencyFrom>()();
    final to = getIt.get<GetCurrencyTo>()();
    emit(state.copyWith(
      allCurrencies: allCurrencies,
      toCurrency: to,
      fromCurrency: from,
    ));
    await loadLastRates();
  }

  void onUpdateFromCurrency(Currency newFromCurrency) {
    if (newFromCurrency == state.fromCurrency) return;
    final currentFrom = state.fromCurrency;
    if (newFromCurrency == state.toCurrency) {
      emit(state.copyWith(
          toCurrency: currentFrom, fromCurrency: newFromCurrency));
      getIt.get<SaveCurrencyFrom>()(newFromCurrency);
      getIt.get<SaveCurrencyTo>()(currentFrom);
    } else {
      emit(state.copyWith(fromCurrency: newFromCurrency));
      getIt.get<SaveCurrencyFrom>()(newFromCurrency);
    }
    convert(ConvertType.to);
  }

  void onUpdateToCurrency(Currency newToCurrency) {
    if (newToCurrency == state.toCurrency) return;
    final currentTo = state.toCurrency;
    if (newToCurrency == state.fromCurrency) {
      emit(state.copyWith(fromCurrency: currentTo, toCurrency: newToCurrency));
      getIt.get<SaveCurrencyFrom>()(currentTo);
      getIt.get<SaveCurrencyTo>()(newToCurrency);
    } else {
      emit(state.copyWith(toCurrency: newToCurrency));
      getIt.get<SaveCurrencyTo>()(newToCurrency);
    }
    convert(ConvertType.from);
  }

  Future<void> loadLastRates() async {
    emit(state.copyWith(status: PageStatus.loading));
    try {
      final rates = await getIt.get<GetLastRates>()();
      if (rates.isEmpty) {
        emit(state.copyWith(
            status: PageStatus.error, errorMessage: _defaultErrorMessage));
      } else {
        emit(state.copyWith(rates: rates, status: PageStatus.loaded));
        convert(ConvertType.from);
      }
    } catch (e) {
      String errorMessage = _defaultErrorMessage;
      if (e is AppException) {
        errorMessage = e.errorText;
      }
      emit(
          state.copyWith(status: PageStatus.error, errorMessage: errorMessage));
    }
  }

  void updateFrom(String newValue, bool needConvert) {
    emit(state.copyWith(fromValue: newValue));
    if (needConvert) convert(ConvertType.from);
  }

  void switchCurrencies() {
    onUpdateToCurrency(state.fromCurrency);
    emit(state.copyWith(toValue: state.fromValue, fromValue: state.toValue));
    controllerTo.text = state.toValue;
    controllerFrom.text = state.fromValue;
  }

  void updateTo(String newValue, bool needConvert) {
    emit(state.copyWith(toValue: newValue));
    if (needConvert) convert(ConvertType.to);
  }

  void convert(ConvertType convertType) {
    switch (convertType) {
      case ConvertType.from:
        CurrencyRate rateFrom = state.getRateByCode(state.fromCurrency.code);
        CurrencyRate rateTo = state.getRateByCode(state.toCurrency.code);
        final valueFromInUsd =
            rateTo.rate * (double.tryParse(state.fromValue) ?? 0);
        final valueToInUsd = valueFromInUsd / rateFrom.rate;
        String result = valueToInUsd.toStringAsFixed(2);
        updateTo(valueToInUsd.toStringAsFixed(2), false);
        controllerTo.text = result;
      case ConvertType.to:
        CurrencyRate rateFrom = state.getRateByCode(state.fromCurrency.code);
        CurrencyRate rateTo = state.getRateByCode(state.toCurrency.code);
        final valueFromInUsd =
            rateFrom.rate * (double.tryParse(state.toValue) ?? 0);
        final valueToInUsd = valueFromInUsd / rateTo.rate;
        String result = valueToInUsd.toStringAsFixed(2);
        updateFrom(valueToInUsd.toStringAsFixed(2), false);
        controllerFrom.text = result;
    }
  }
}
