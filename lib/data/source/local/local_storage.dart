import 'package:shared_preferences/shared_preferences.dart';

const String keyCurrencyFrom = 'KEY_CURRENCY_FROM';
const String keyCurrencyTo = 'KEY_CURRENCY_TO';

abstract class LocalStorage {
  String? getString({required String key});

  Future<void> saveString({required String key, required String value});
}

class LocalStorageImpl implements LocalStorage {
  final SharedPreferences _sharedPref;

  LocalStorageImpl({
    required SharedPreferences sharedPreferences,
  }) : _sharedPref = sharedPreferences;

  @override
  String? getString({required String key}) {
    return _sharedPref.getString(key);
  }

  @override
  Future<void> saveString({required String key, required String value}) async {
    await _sharedPref.setString(key, value);
  }
}
