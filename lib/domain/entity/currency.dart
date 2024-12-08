import 'package:equatable/equatable.dart';

class Currency with EquatableMixin {
  final String code;
  final String name;
  final String country;
  final String countryCode;

  @override
  List<Object?> get props => [code, name, countryCode, countryCode];

  const Currency({
    required this.code,
    required this.name,
    required this.country,
    required this.countryCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'country': country,
      'countryCode': countryCode,
    };
  }

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      code: map['code'] as String,
      name: map['name'] as String,
      country: map['country'] as String,
      countryCode: map['countryCode'] as String,
    );
  }

  static const rub = Currency(
    name: 'Ruble',
    code: 'RUB',
    country: 'Russia',
    countryCode: 'ru',
  );

  static const usd = Currency(
    name: 'US Dollar',
    code: 'USD',
    country: 'USA',
    countryCode: 'us',
  );
}
