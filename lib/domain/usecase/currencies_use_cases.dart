import 'package:currency_exchange/domain/entity/currency.dart';
import 'package:currency_exchange/domain/repository/currency_repository.dart';

class GetAllCurrencies {
  GetAllCurrencies({
    required CurrencyRepository repository,
  }) : _repository = repository;

  final CurrencyRepository _repository;

  Future<List<Currency>> call() async {
    final list = await _repository.getAllCurrencies();
    return list;
  }
}

class SaveCurrencyTo {
  SaveCurrencyTo({
    required CurrencyRepository repository,
  }) : _repository = repository;

  final CurrencyRepository _repository;

  Future<void> call(Currency currency) async {
    await _repository.saveCurrencyTo(currency);
  }
}

class SaveCurrencyFrom {
  SaveCurrencyFrom({
    required CurrencyRepository repository,
  }) : _repository = repository;

  final CurrencyRepository _repository;

  Future<void> call(Currency currency) async {
    await _repository.saveCurrencyFrom(currency);
  }
}

class GetCurrencyTo {
  GetCurrencyTo({
    required CurrencyRepository repository,
  }) : _repository = repository;

  final CurrencyRepository _repository;

  Currency? call() {
    return _repository.getCurrencyTo();
  }
}

class GetCurrencyFrom {
  GetCurrencyFrom({
    required CurrencyRepository repository,
  }) : _repository = repository;

  final CurrencyRepository _repository;

  Currency? call() {
    return _repository.getCurrencyFrom();
  }
}



