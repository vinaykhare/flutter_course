import '../models/transaction.dart';
import './transaction_card.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function delTrx;
  const TransactionList(
      {Key? key, required this.userTransactions, required this.delTrx})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return userTransactions.isEmpty
        ? LayoutBuilder(builder: (context, emptyScreenContraints) {
            return Column(
              children: [
                SizedBox(
                  height: emptyScreenContraints.maxHeight * 0.1,
                ),
                const Text(
                  'No transactions added yet!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: emptyScreenContraints.maxHeight * 0.1,
                ),
                SizedBox(
                  height: emptyScreenContraints.maxHeight * 0.4,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: userTransactions.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 10,
                //color: Theme.of(context).backgroundColor,
                child: TransactionCard(
                    trx: userTransactions[index], deleteTrx: delTrx),
              );
            },
          );
  }
}
