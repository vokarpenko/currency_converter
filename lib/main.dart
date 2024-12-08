import 'package:currency_exchange/presentation/app.dart';
import 'package:flutter/material.dart';
import 'service_locator.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const ExchangeApp());
}
