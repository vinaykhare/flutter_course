import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CupertinoAddTransaction extends StatefulWidget {
  final Function addTransaction;

  const CupertinoAddTransaction({Key? key, required this.addTransaction})
      : super(key: key);

  @override
  State<CupertinoAddTransaction> createState() =>
      _CupertinoAddTransactionState();
}

class _CupertinoAddTransactionState extends State<CupertinoAddTransaction> {
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

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  void getDatePicker() {
    _showDialog(
      CupertinoDatePicker(
        //context: context,
        initialDateTime: DateTime.now(),
        maximumDate: DateTime.now(),
        minimumDate: DateTime(2022),
        onDateTimeChanged: (value) {
          setState(() {
            trxDate = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Card(
        color: CupertinoTheme.of(context).barBackgroundColor,
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
              CupertinoTextField(
                placeholder: 'Title',
                style: Theme.of(context).textTheme.headline6,
                controller: titleController,
                onSubmitted: (str) {
                  addTx();
                },
              ),
              CupertinoTextField(
                placeholder: 'Amount',
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
                    CupertinoButton(
                      onPressed: getDatePicker,
                      child: const Icon(Icons.calendar_month_outlined),
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
      ),
    );
  }
}
