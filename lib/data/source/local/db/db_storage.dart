import 'package:currency_exchange/data/source/dto/currency_rate_model.dart';
import 'package:currency_exchange/data/source/local/db/db_helper.dart';
import 'package:sembast/sembast.dart';

abstract class DatabaseStorage {
  Future<void> saveCurrencyRates(List<CurrencyRateModel> rates);

  Future<List<CurrencyRateModel>> getAllCurrencyRates();

  Future<void> deleteAllRates();
}

class DatabaseStorageImpl implements DatabaseStorage {
  final _storeRates = intMapStoreFactory.store('rates');

  @override
  Future<void> saveCurrencyRates(List<CurrencyRateModel> rates) async {
    final db = await DBHelper().database;
    await _storeRates.addAll(db, rates.map((e) => e.toMap()).toList());
  }

  @override
  Future<List<CurrencyRateModel>> getAllCurrencyRates() async {
    final db = await DBHelper().database;

    final records = await _storeRates.find(
      db,
    );
    return records.map((record) {
      return CurrencyRateModel.fromMap(record.value);
    }).toList();
  }

  @override
  Future<void> deleteAllRates() async {
    final db = await DBHelper().database;
    await _storeRates.delete(db);
  }
}
