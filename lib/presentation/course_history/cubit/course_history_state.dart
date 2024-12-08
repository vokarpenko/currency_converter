import 'package:currency_exchange/domain/entity/course_history_chart_item.dart';
import 'package:currency_exchange/presentation/utils/enums.dart';
import 'package:equatable/equatable.dart';

class CourseHistoryState with EquatableMixin {
  final PageStatus status;
  final List<CourseHistoryChartItem> ratesForChart;
  final String errorMessage;

  @override
  List<Object?> get props => [status, ratesForChart, errorMessage];

  const CourseHistoryState({
    this.status = PageStatus.loading,
    this.ratesForChart = const [],
    this.errorMessage = '',
  });

  CourseHistoryState copyWith({
    PageStatus? status,
    List<CourseHistoryChartItem>? ratesForChart,
    String? errorMessage,
  }) {
    return CourseHistoryState(
      status: status ?? this.status,
      ratesForChart: ratesForChart ?? this.ratesForChart,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
