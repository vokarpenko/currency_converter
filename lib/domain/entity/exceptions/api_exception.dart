import 'package:currency_exchange/domain/entity/exceptions/app_exception.dart';

class ApiException extends AppException{
  ApiException({required super.errorText});
}