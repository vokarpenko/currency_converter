import 'package:equatable/equatable.dart';

class CurrencyRate with EquatableMixin {
  final String codeFrom;
  final String codeTo;
  final double rate;
  final DateTime date;

  @override
  List<Object?> get props => [codeFrom, codeTo, rate, date];

  const CurrencyRate({
    required this.codeFrom,
    required this.codeTo,
    required this.rate,
    required this.date,
  });
}

