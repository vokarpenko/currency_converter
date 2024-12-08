class CurrencyRateDto {
  String? date;
  Map<String,dynamic>? rates;

  CurrencyRateDto.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    rates = json['usd'] != null ? json['usd'] as Map<String,dynamic> : null;
  }
}

