import 'package:flutter/services.dart';

class MoneyInputFormatter extends TextInputFormatter {
  static RegExp moneyRegExp = RegExp(r'^\d{0,15}(\.\d{0,2})?$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    print(text);
    if (moneyRegExp.hasMatch(text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}
