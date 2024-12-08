import 'package:currency_exchange/domain/entity/currency_rate.dart';

class CurrencyRateModel extends CurrencyRate {
  const CurrencyRateModel({
    required super.codeFrom,
    required super.codeTo,
    required super.rate,
    required super.date,
  });

  factory CurrencyRateModel.fromMap(Map<String, dynamic> map) {
    return CurrencyRateModel(
      codeFrom: map['codeFrom'],
      codeTo: map['codeTo'],
      rate: map['rate'],
      date: DateTime.parse(map['date']),
    );
  }

  factory CurrencyRateModel.fromCurrencyRate(CurrencyRate currency) {
    return CurrencyRateModel(
      codeFrom: currency.codeFrom,
      codeTo: currency.codeTo,
      rate: currency.rate,
      date: currency.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codeFrom': codeFrom,
      'codeTo': codeTo,
      'rate': rate,
      'date': date.toIso8601String(),
    };
  }
}
