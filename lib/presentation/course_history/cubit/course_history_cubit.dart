import 'package:bloc/bloc.dart';
import 'package:currency_exchange/domain/entity/currency.dart';
import 'package:currency_exchange/domain/usecase/rates_use_cases.dart';
import 'package:currency_exchange/presentation/course_history/cubit/course_history_state.dart';
import 'package:currency_exchange/presentation/utils/enums.dart';
import 'package:currency_exchange/service_locator.dart';

class CourseHistoryCubit extends Cubit<CourseHistoryState> {
  static const String _defaultErrorMessage = 'Error getting course history';
  final Currency fromCurrency;
  final Currency toCurrency;

  CourseHistoryCubit({
    required this.fromCurrency,
    required this.toCurrency,
  }) : super(const CourseHistoryState()) {
    _init();
  }

  void _init() {
    loadingHistory();
  }

  Future<void> loadingHistory() async {
    try {
      final now = DateTime.now();
      var currentDate = DateTime(now.year, now.month, now.day);
      final starTime = DateTime.now();
      final listForChart = await getIt.get<GetRatesForChartByPeriod>()(
        from: fromCurrency,
        to: toCurrency,
        start: currentDate.subtract(const Duration(days: 30)),
        end: currentDate,
      );
      final endTime = DateTime.now();
      print(starTime.difference(endTime).inSeconds);
      emit(state.copyWith(
          status: PageStatus.loaded, ratesForChart: listForChart));
    } catch (e) {
      emit(state.copyWith(
          status: PageStatus.error, errorMessage: _defaultErrorMessage));
    }
  }
}
