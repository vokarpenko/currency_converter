class Endpoints {
  Endpoints._();

  static const lastRates =
      'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json';

  static String ratesFrom(String date) =>
      'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@$date/v1/currencies/usd.json';
}
