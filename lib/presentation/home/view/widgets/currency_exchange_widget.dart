import 'package:currency_exchange/domain/entity/currency.dart';
import 'package:currency_exchange/presentation/utils/money_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CurrencyExchangeWidget extends StatelessWidget {
  final Currency currency;
  final VoidCallback onTap;
  final Function(String)? onChange;
  final TextEditingController controller;
  final FocusNode focusNode = FocusNode();

  CurrencyExchangeWidget({
    super.key,
    required this.currency,
    required this.onTap,
    this.onChange,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: const [
                        BoxShadow(color: Colors.grey, blurRadius: 7),
                      ],
                    ),
                    height: 70,
                    width: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SvgPicture.asset(
                        fit: BoxFit.cover,
                        'assets/icons/flags/${currency.countryCode.toLowerCase()}.svg',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(currency.code.toUpperCase()),
                ],
              ),
            ),
          ),
          const SizedBox(width: 40),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  child: TextField(
                    onTap: (controller.text.length >= 15)
                        ? () {
                            controller.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: controller.value.text.length);
                          }
                        : null,
                    textAlign: TextAlign.end,
                    controller: controller,
                    onChanged:
                        onChange != null ? (value) => onChange!(value) : null,
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    inputFormatters: [MoneyInputFormatter()],
                  ),
                ),
                Text(currency.name),
              ],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
