import 'package:currency_exchange/domain/entity/course_history_chart_item.dart';
import 'package:currency_exchange/domain/entity/currency.dart';
import 'package:currency_exchange/domain/entity/currency_rate.dart';
import 'package:currency_exchange/domain/repository/rates_repository.dart';
import 'package:collection/collection.dart';

class GetRatesForChartByPeriod {
  GetRatesForChartByPeriod({
    required RatesRepository repository,
  }) : _repository = repository;

  final RatesRepository _repository;

  Future<List<CourseHistoryChartItem>> call({
    required DateTime start,
    required DateTime end,
    required Currency from,
    required Currency to,
  }) async {
    final List<CourseHistoryChartItem> result = [];

    final Map<DateTime, List<CurrencyRate>> rates =
        await _repository.getCurrencyRatesByPeriod(start: start, end: end);
    if (rates.entries.isNotEmpty) {
      rates.forEach(
        (key, value) {
          final fromOriginCurrencyToUsd = value.firstWhereOrNull(
            (rate) => rate.codeFrom.toLowerCase() == from.code.toLowerCase(),
          );
          final usdToResultCurrency = value.firstWhereOrNull(
            (rate) => rate.codeFrom.toLowerCase() == to.code.toLowerCase(),
          );
          if (fromOriginCurrencyToUsd != null && usdToResultCurrency != null) {
            result.add(
              CourseHistoryChartItem(
                day: key,
                value: double.parse(
                    (usdToResultCurrency.rate / fromOriginCurrencyToUsd.rate)
                        .toStringAsFixed(4)),
              ),
            );
          }
        },
      );
    }
    result.sort((a, b) => a.day.isAfter(b.day) ? 1 : -1);
    return result;
  }
}

class GetLastRates {
  GetLastRates({
    required RatesRepository repository,
  }) : _repository = repository;

  final RatesRepository _repository;

  Future<List<CurrencyRate>> call() async {
    return await _repository.loadLastRates();
  }
}
