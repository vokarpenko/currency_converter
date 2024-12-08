import 'package:equatable/equatable.dart';

class CourseHistoryChartItem with EquatableMixin {
  final DateTime day;
  final double value;

  const CourseHistoryChartItem({
    required this.day,
    required this.value,
  });

  @override
  List<Object?> get props => [day, value];
}
