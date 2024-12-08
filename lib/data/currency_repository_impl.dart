import 'dart:convert';

import 'package:currency_exchange/data/source/local/assets_storage.dart';
import 'package:currency_exchange/data/source/local/local_storage.dart';
import 'package:currency_exchange/domain/entity/currency.dart';
import 'package:currency_exchange/domain/repository/currency_repository.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final AssetsStorage _assetsStorage;
  final LocalStorage _localStorage;

  CurrencyRepositoryImpl({
    required AssetsStorage assetsStorage,
    required LocalStorage localStorage,
  })  : _assetsStorage = assetsStorage,
        _localStorage = localStorage;

  @override
  Future<List<Currency>> getAllCurrencies() async {
    final json = (await _assetsStorage.loadJson(
        path: 'assets/json/currencies.json') as List<dynamic>);
    final result =
        json.map((e) => Currency.fromMap(e as Map<String, dynamic>)).toList();
    return result;
  }

  @override
  Currency? getCurrencyFrom() {
    String? stringCurrency = _localStorage.getString(key: keyCurrencyFrom);
    if (stringCurrency == null) return null;
    return Currency.fromMap(jsonDecode(stringCurrency) as Map<String, dynamic>);
  }

  @override
  Currency? getCurrencyTo() {
    String? stringCurrency = _localStorage.getString(key: keyCurrencyTo);
    if (stringCurrency == null) return null;
    return Currency.fromMap(jsonDecode(stringCurrency) as Map<String, dynamic>);
  }

  @override
  Future<void> saveCurrencyFrom(Currency currency) async {
    await _localStorage.saveString(
        key: keyCurrencyFrom, value: jsonEncode(currency.toMap()));
  }

  @override
  Future<void> saveCurrencyTo(Currency currency) async {
    await _localStorage.saveString(
        key: keyCurrencyTo, value: jsonEncode(currency.toMap()));
  }
}
