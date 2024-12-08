import 'package:currency_exchange/data/source/dto/currency_rate_model.dart';
import 'package:currency_exchange/data/source/local/db/db_storage.dart';
import 'package:currency_exchange/data/source/network/api.dart';
import 'package:currency_exchange/domain/entity/currency_rate.dart';
import 'package:currency_exchange/domain/repository/rates_repository.dart';

class RatesRepositoryImpl implements RatesRepository {
  final Api _api;
  final DatabaseStorage _dbStorage;

  RatesRepositoryImpl({
    required Api api,
    required DatabaseStorage dbStorage,
  })  : _api = api,
        _dbStorage = dbStorage;

  @override
  Future<List<CurrencyRate>> loadLastRates() async {
    try {
      final response = await _api.loadLastRates();
      final result = response.rates!.entries
          .map(
            (e) => CurrencyRate(
              codeFrom: e.key.toLowerCase(),
              codeTo: 'usd',
              rate: double.parse(e.value.toString()),
              date: DateTime.parse(
                response.date!,
              ),
            ),
          )
          .toList();
      return result;
    } catch (e) {
      final ratesFromDb = (await _dbStorage.getAllCurrencyRates()).toList();
      if (ratesFromDb.isNotEmpty) {
        ratesFromDb.sort(
          (a, b) => a.date.isAfter(b.date) ? 1 : -1,
        );
        return ratesFromDb;
      }
    }
    return [];
  }

  @override
  Future<Map<DateTime, List<CurrencyRate>>> getCurrencyRatesByPeriod({
    required DateTime start,
    required DateTime end,
  }) async {
    Map<DateTime, List<CurrencyRate>> result = {};
    final ratesFromDb = (await _dbStorage.getAllCurrencyRates())
        .where((rate) =>
            rate.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
            rate.date.isBefore(end.add(const Duration(seconds: 1))))
        .toList();

    final countOfDay = end.difference(start).inDays;
    DateTime currentDate = DateTime(end.year, end.month, end.day);

    for (int index = 0; index < countOfDay; index++) {
      final rateFromDb = ratesFromDb
          .where((rate) => rate.date.isAtSameMomentAs(currentDate))
          .toList();

      if (rateFromDb.isNotEmpty) {
        result.addEntries([MapEntry(currentDate, rateFromDb)]);
      } else {
        try {
          final ratesFromApi = await _api.loadRatesByDate(currentDate);
          if (ratesFromApi.rates != null) {
            final List<CurrencyRate> currencyRates =
                ratesFromApi.rates!.entries.map(
              (e) {
                final rate = CurrencyRate(
                  codeFrom: e.key.toLowerCase(),
                  codeTo: 'usd',
                  rate: double.parse(e.value.toString()),
                  date: DateTime.parse(
                    ratesFromApi.date!,
                  ),
                );
                return rate;
              },
            ).toList();
            result.addEntries([MapEntry(currentDate, currencyRates)]);
            _dbStorage.saveCurrencyRates(currencyRates
                .map((e) => CurrencyRateModel.fromCurrencyRate(e))
                .toList());
          }
        } catch (e) {
          //nothing
        }
      }
      currentDate = currentDate.subtract(const Duration(days: 1));
    }
    return result;
  }
}
