import 'package:currency_exchange/domain/entity/course_history_chart_item.dart';
import 'package:currency_exchange/domain/entity/currency.dart';
import 'package:currency_exchange/presentation/course_history/cubit/course_history_cubit.dart';
import 'package:currency_exchange/presentation/course_history/cubit/course_history_state.dart';
import 'package:currency_exchange/presentation/utils/date_formatter.dart';
import 'package:currency_exchange/presentation/utils/enums.dart';
import 'package:currency_exchange/presentation/widgets/error_widget.dart';
import 'package:currency_exchange/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CourseHistoryPage extends StatelessWidget {
  const CourseHistoryPage({
    super.key,
    required this.fromCurrency,
    required this.toCurrency,
  });

  final Currency fromCurrency;
  final Currency toCurrency;

  static MaterialPageRoute route({
    required Currency fromCurrency,
    required Currency toCurrency,
  }) {
    return MaterialPageRoute(
      builder: (BuildContext context) => CourseHistoryPage(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CourseHistoryCubit(
          fromCurrency: fromCurrency, toCurrency: toCurrency),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final cubit = BlocProvider.of<CourseHistoryCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course history'),
      ),
      body: BlocBuilder<CourseHistoryCubit, CourseHistoryState>(
        builder: (context, state) {
          switch (state.status) {
            case PageStatus.loading:
              return const Loading();
            case PageStatus.loaded:
              return Column(
                children: [
                  Center(
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        interval: 8,
                        axisLabelFormatter: (axisLabelRenderArgs) =>
                            ChartAxisLabel(
                          DateFormatter.formatDDMMM(
                              DateTime.parse(axisLabelRenderArgs.text)),
                          DefaultTextStyle.of(context).style,
                        ),
                      ),
                      title: ChartTitle(
                          text:
                              'Last 30 days, ${fromCurrency.code.toUpperCase()} - ${toCurrency.code.toUpperCase()}'),
                      trackballBehavior: TrackballBehavior(
                        builder: (context, trackballDetails) {
                          num index = trackballDetails.point?.xValue ?? 0;
                          DateTime date =
                              (trackballDetails.series.xRawValues[index]);
                          double value =
                              (trackballDetails.series.yValues[index]);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.withOpacity(0.3)),
                            child: RichText(
                              text: TextSpan(
                                text: '${value.toStringAsFixed(4)} ',
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(fontWeight: FontWeight.w500),
                                children: [
                                  TextSpan(
                                    text: DateFormatter.formatEEEddMMM(date),
                                    style: DefaultTextStyle.of(context).style,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        enable: true,
                        activationMode: ActivationMode.singleTap,
                      ),
                      // Series
                      series: <LineSeries<CourseHistoryChartItem, DateTime>>[
                        LineSeries<CourseHistoryChartItem, DateTime>(
                          dataSource: state.ratesForChart,
                          xValueMapper: (CourseHistoryChartItem rate, _) =>
                              rate.day,
                          yValueMapper: (CourseHistoryChartItem rate, _) =>
                              rate.value,
                        )
                      ],
                    ),
                  )
                ],
              );
            case PageStatus.error:
              return ErrorTextWidget(message: state.errorMessage);
          }
        },
      ),
    );
  }
}
