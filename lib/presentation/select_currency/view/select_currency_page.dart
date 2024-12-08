import 'package:currency_exchange/domain/entity/currency.dart';
import 'package:currency_exchange/presentation/select_currency/view/widget/currency_item_widget.dart';
import 'package:flutter/material.dart';

class SelectCurrencyPage extends StatelessWidget {
  final List<Currency> currencies;
  final Function(Currency newCurrency) onSelectCurrency;

  const SelectCurrencyPage({
    super.key,
    required this.currencies,
    required this.onSelectCurrency,
  });

  static MaterialPageRoute route({
    required List<Currency> currencies,
    required Function(Currency newCurrency) onSelectCurrency,
  }) {
    return MaterialPageRoute(
      builder: (BuildContext context) => SelectCurrencyPage(
        currencies: currencies,
        onSelectCurrency: onSelectCurrency,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currencies'),
      ),
      body: ListView.builder(
        itemCount: currencies.length,
        itemBuilder: (context, index) {
          final currency = currencies[index];
          return CurrencyItemWidget(
            key: ValueKey(currency.code),
            currency: currency,
            onTap: onSelectCurrency,
          );
        },
      ),
    );
  }
}
