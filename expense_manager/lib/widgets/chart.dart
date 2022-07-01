import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';

import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> userTransactions;
  const Chart({Key? key, required this.userTransactions}) : super(key: key);

  List<ChartBar> get recentTransactions {
    Map<String, double> trxInlastSevenDaysGrouped = {};
    double maxAmount = 0.0;

    //Create Group of Weekdays
    for (int i = 6; i >= 0; i--) {
      DateTime weekDayDate = DateTime.now().subtract(Duration(days: i));
      String weekDay = DateFormat.E().format(weekDayDate);
      trxInlastSevenDaysGrouped[weekDay] = 0.0;
    }

    //Populate amount to group of weekdays
    for (var trx in userTransactions) {
      var fromDate = DateTime.now().subtract(const Duration(days: 7));
      if (trx.date.isAfter(fromDate)) {
        String mapKey = DateFormat.E().format(trx.date);
        double amount = trxInlastSevenDaysGrouped[mapKey] ?? 0.0;
        amount += trx.amount;
        trxInlastSevenDaysGrouped[mapKey] = amount;
        maxAmount = amount > maxAmount ? amount : maxAmount;
      }
    }

    List<ChartBar> bars = [];
    trxInlastSevenDaysGrouped.forEach((key, value) {
      bars.add(ChartBar(
        day: key,
        amount: value,
        maxAmount: maxAmount,
      ));
    });
    return bars;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 10,
      //color: Theme.of(context).backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: recentTransactions,
      ),
    );
  }
}
