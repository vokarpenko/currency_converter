import 'package:currency_exchange/presentation/course_history/view/course_history_page.dart';
import 'package:currency_exchange/presentation/home/cubit/home_cubit.dart';
import 'package:currency_exchange/presentation/home/cubit/home_state.dart';
import 'package:currency_exchange/presentation/home/view/widgets/currency_exchange_widget.dart';
import 'package:currency_exchange/presentation/select_currency/view/select_currency_page.dart';
import 'package:currency_exchange/presentation/utils/enums.dart';
import 'package:currency_exchange/presentation/widgets/error_widget.dart';
import 'package:currency_exchange/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeCubit(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Currency Converter',
            style: TextStyle(color: Theme.of(context).colorScheme.surface),
          ),
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            switch (state.status) {
              case PageStatus.loading:
                return const Loading();
              case PageStatus.loaded:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    CurrencyExchangeWidget(
                      currency: state.fromCurrency,
                      onTap: () {
                        Navigator.push(
                          context,
                          SelectCurrencyPage.route(
                            currencies: state.allCurrencies,
                            onSelectCurrency: cubit.onUpdateFromCurrency,
                          ),
                        );
                      },
                      onChange: (value) {
                        cubit.updateFrom(value, true);
                      },
                      controller: cubit.controllerFrom,
                    ),
                    CurrencyExchangeWidget(
                      currency: state.toCurrency,
                      onTap: () {
                        Navigator.push(
                          context,
                          SelectCurrencyPage.route(
                            currencies: state.allCurrencies,
                            onSelectCurrency: cubit.onUpdateToCurrency,
                          ),
                        );
                      },
                      onChange: (value) {
                        cubit.updateTo(value, true);
                      },
                      controller: cubit.controllerTo,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          FilledButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CourseHistoryPage.route(
                                      fromCurrency: state.fromCurrency,
                                      toCurrency: state.toCurrency),
                                );
                              },
                              child: const Text('Exchange rate history')),
                          IconButton(
                            padding: EdgeInsets.zero,
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              cubit.switchCurrencies();
                            },
                            icon: const RotatedBox(
                              quarterTurns: 3,
                              child: Icon(
                                Icons.swap_horizontal_circle,
                                size: 45,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              case PageStatus.error:
                return ErrorTextWidget(message: state.errorMessage);
            }
          },
        ),
      ),
    );
  }
}
