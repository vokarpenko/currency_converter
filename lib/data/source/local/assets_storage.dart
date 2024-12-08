import 'dart:convert';

import 'package:flutter/services.dart';

abstract class AssetsStorage {
  Future<dynamic> loadJson({required String path});
}

class AssetsStorageImpl implements AssetsStorage {
  @override
  Future<dynamic> loadJson({required String path}) async {
    String data = await rootBundle.loadString('assets/json/currencies.json');
    final jsonResult = jsonDecode(data);
    return jsonResult;
  }
}
