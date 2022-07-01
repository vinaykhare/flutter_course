import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction trx;
  final Function deleteTrx;
  const TransactionCard({Key? key, required this.trx, required this.deleteTrx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          width: 100,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).primaryColor,
            border: Border.all(
                //color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          child: FittedBox(
            child: Text(
              'Rs. ${trx.amount.toStringAsFixed(2)}/-',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: Text(
          trx.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          DateFormat.yMMMd().add_jm().format(trx.date),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            //fontSize: 14,
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            deleteTrx(trx.id);
          },
          icon: const Icon(Icons.delete),
          color: Theme.of(context).errorColor,
        ));

    // return Card(
    //   elevation: 5,
    //   color: Theme.of(context).colorScheme.background,
    //   child: Row(
    //     children: [
    //       Container(
    //           padding: const EdgeInsets.all(10),
    //           margin: const EdgeInsets.symmetric(
    //             vertical: 10,
    //             horizontal: 15,
    //           ),
    //           decoration: BoxDecoration(
    //             border: Border.all(
    //               color: Theme.of(context).colorScheme.secondary,
    //             ),
    //           ),
    //           child: Text(
    //             'Rs. ${trx.amount.toStringAsFixed(2)}/-',
    //             style: TextStyle(
    //               fontWeight: FontWeight.bold,
    //               color: Theme.of(context).colorScheme.secondary,
    //               fontSize: 20,
    //             ),
    //           )),
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             trx.title,
    //             style: TextStyle(
    //               color: Theme.of(context).colorScheme.secondary,
    //               fontWeight: FontWeight.bold,
    //               fontSize: 20,
    //             ),
    //           ),
    //           Text(
    //             DateFormat.yMMMd().add_jm().format(trx.date),
    //             style: TextStyle(
    //               color: Theme.of(context).colorScheme.secondary,
    //               fontWeight: FontWeight.bold,
    //               fontSize: 14,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
