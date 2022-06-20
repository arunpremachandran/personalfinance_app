import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/widgets/chart_data.dart';
import '../model/expense.dart';

class Chart extends StatelessWidget {
  final List<Expense> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String, Object>> get groupedExpenseValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index),
      );
      double totalSum = 0.0;

      for(var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == weekday.day &&
            recentTransaction[i].date.month == weekday.month &&
            recentTransaction[i].date.year == weekday.year
        ) {
          totalSum += recentTransaction[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekday).substring(0,1),
        'amount': totalSum,
      };
  }).reversed.toList();
}

  double get totalSpending{
      return groupedExpenseValues.fold(0.0, (sum, item) {
        return sum + (item['amount'] as double);
      });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedExpenseValues);
    return Card(
      elevation: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: groupedExpenseValues.map((data) {
          return Flexible(
            fit: FlexFit.tight,
            child:  ChartBar(data['day'].toString(),
              data['amount'] as double,
              totalSpending == 0.0 ? 0.0 : (data['amount'] as double ) / totalSpending),
          );
        }).toList(),
      ),
    );
  }
}
