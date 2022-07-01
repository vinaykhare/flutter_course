import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String day;
  final double amount;
  final double maxAmount;
  const ChartBar(
      {Key? key,
      required this.day,
      required this.amount,
      required this.maxAmount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, chartbarConstraints) {
      return Column(
        children: [
          SizedBox(
            height: chartbarConstraints.maxHeight * 0.10,
            child: FittedBox(
              child: Text(
                '$amount',
              ),
            ),
          ),
          SizedBox(
            height: chartbarConstraints.maxHeight * 0.05,
          ),
          SizedBox(
            height: chartbarConstraints.maxHeight * 0.70,
            width: 15,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: Theme.of(context).primaryColorDark),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: maxAmount > 0 ? (amount / maxAmount) : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: Theme.of(context).primaryColorDark),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: chartbarConstraints.maxHeight * 0.05,
          ),
          SizedBox(
            height: chartbarConstraints.maxHeight * 0.10,
            child: FittedBox(
              child: Text(
                day,
              ),
            ),
          ),
        ],
      );
    });
  }
}
