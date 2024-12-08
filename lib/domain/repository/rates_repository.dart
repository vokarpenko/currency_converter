import 'package:currency_exchange/domain/entity/currency_rate.dart';

abstract class RatesRepository {
  Future<List<CurrencyRate>> loadLastRates();

  Future<Map<DateTime, List<CurrencyRate>>> getCurrencyRatesByPeriod({
    required DateTime start,
    required DateTime end,
  });
}
