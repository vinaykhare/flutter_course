import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  final Function addTransaction;

  const AddTransaction({Key? key, required this.addTransaction})
      : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  DateTime trxDate = DateTime.now();

  void addTx() {
    widget.addTransaction(
      titleController.text,
      amountController.text,
      trxDate,
    );
    Navigator.pop(context);
  }

  void getDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    ).then((value) {
      setState(() {
        trxDate = value ?? DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: mediaQuery.viewInsets.bottom,
          top: 10,
          left: 10,
          right: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              style: Theme.of(context).textTheme.headline6,
              controller: titleController,
              onSubmitted: (str) {
                addTx();
              },
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              style: Theme.of(context).textTheme.headline6,
              controller: amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (str) {
                addTx();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat.yMEd().format(trxDate)),
                  IconButton(
                    onPressed: getDatePicker,
                    icon: const Icon(Icons.calendar_month_outlined),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                addTx();
              },
              child: const Text("Add Transaction"),
            )
          ],
        ),
      ),
    );
  }
}
