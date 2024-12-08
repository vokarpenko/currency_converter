import 'package:currency_exchange/domain/entity/currency.dart';

abstract class CurrencyRepository {
  Future<List<Currency>> getAllCurrencies();

  Currency? getCurrencyFrom();

  Currency? getCurrencyTo();

  Future<void> saveCurrencyFrom(Currency currency);

  Future<void> saveCurrencyTo(Currency currency);
}
