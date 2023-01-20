import 'package:expenses/components/chart_bar.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart({Key? key, required this.recentTransactions}) : super(key: key);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSumDay = 0.0;
      for (var transaction in recentTransactions) {
        if (DateUtils.isSameDay(transaction.date, weekDay)) {
          totalSumDay += transaction.value;
        }
      }

      return {'day': DateFormat.E().format(weekDay)[0], 'value': totalSumDay};
    }).reversed.toList();
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(
        0.0, (sum, transaction) => sum + (transaction['value'] as double));
  }

  @override
  Widget build(BuildContext context) {
    final weekTotalValue = _weekTotalValue;

    return Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: groupedTransactions
                  .map((transaction) => Flexible(
                        fit: FlexFit.tight,
                        child: ChartBar(
                            label: transaction['day'].toString(),
                            value: transaction['value'] as double,
                            percentage: weekTotalValue == 0
                                ? 0
                                : (transaction['value'] as double) /
                                    weekTotalValue),
                      ))
                  .toList()),
        ));
  }
}
