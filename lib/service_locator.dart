import 'package:currency_exchange/data/currency_repository_impl.dart';
import 'package:currency_exchange/data/rates_repository_impl.dart';
import 'package:currency_exchange/data/source/local/assets_storage.dart';
import 'package:currency_exchange/data/source/local/db/db_storage.dart';
import 'package:currency_exchange/data/source/local/local_storage.dart';
import 'package:currency_exchange/data/source/network/api.dart';
import 'package:currency_exchange/domain/usecase/currencies_use_cases.dart';
import 'package:currency_exchange/domain/usecase/rates_use_cases.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  final api = ApiImpl();
  final assetsStorageImpl = AssetsStorageImpl();
  final sharedPrefs = await SharedPreferences.getInstance();
  final localStorageImpl = LocalStorageImpl(sharedPreferences: sharedPrefs);
  final dbStorage = DatabaseStorageImpl();

  final currencyRepositoryImpl = CurrencyRepositoryImpl(
    assetsStorage: assetsStorageImpl,
    localStorage: localStorageImpl,
  );

  final ratesRepositoryImpl = RatesRepositoryImpl(
    api: api,
    dbStorage: dbStorage,
  );

  // Use Cases
  getIt.registerLazySingleton(
      () => GetAllCurrencies(repository: currencyRepositoryImpl));
  getIt.registerLazySingleton(
      () => GetCurrencyFrom(repository: currencyRepositoryImpl));
  getIt.registerLazySingleton(
      () => GetCurrencyTo(repository: currencyRepositoryImpl));
  getIt.registerLazySingleton(
      () => SaveCurrencyFrom(repository: currencyRepositoryImpl));
  getIt.registerLazySingleton(
      () => SaveCurrencyTo(repository: currencyRepositoryImpl));
  getIt.registerLazySingleton(
      () => GetLastRates(repository: ratesRepositoryImpl));

  getIt.registerLazySingleton(
      () => GetRatesForChartByPeriod(repository: ratesRepositoryImpl));
}
