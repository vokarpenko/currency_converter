import 'package:currency_exchange/data/source/dto/currency_rate_dto.dart';
import 'package:currency_exchange/data/source/network/endpoints.dart';
import 'package:currency_exchange/domain/entity/exceptions/api_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

abstract class Api {
  Future<CurrencyRateDto> loadLastRates();

  Future<CurrencyRateDto> loadRatesByDate(DateTime date);
}

class ApiImpl implements Api {
  final dio = Dio();

  @override
  Future<CurrencyRateDto> loadLastRates() async {
    try {
      final Response<Map<String, dynamic>> response =
          await dio.get(Endpoints.lastRates);
      if ((response.statusCode ?? 500) > 200 || response.data == null) {
        throw ApiException(errorText: 'Load rates error, try again later');
      }
      final result =
          CurrencyRateDto.fromJson(response.data as Map<String, dynamic>);
      return result;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ApiException(errorText: 'Load rates error, try again later');
    }
  }

  @override
  Future<CurrencyRateDto> loadRatesByDate(DateTime date) async {
    print('call api $date');
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    print(formattedDate);
    try {
      final Response<Map<String, dynamic>> response =
          await dio.get(Endpoints.ratesFrom(formattedDate));
      if ((response.statusCode ?? 500) > 200 || response.data == null) {
        throw ApiException(errorText: 'Load rates error, try again later');
      }
      final result =
          CurrencyRateDto.fromJson(response.data as Map<String, dynamic>);
      return result;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ApiException(errorText: 'Load rates error, try again later');
    }
  }
}
