import 'package:currency_exchange/domain/entity/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CurrencyItemWidget extends StatelessWidget {
  const CurrencyItemWidget({
    super.key,
    required this.currency,
    required this.onTap,
  });

  final Currency currency;
  final Function(Currency currency) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(currency);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: const [
                      BoxShadow(color: Colors.grey, blurRadius: 7),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SvgPicture.asset(
                      fit: BoxFit.cover,
                      'assets/icons/flags/${currency.countryCode.toLowerCase()}.svg',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(currency.name),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                currency.code.toUpperCase(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
