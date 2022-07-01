import 'dart:convert';
import 'dart:io';

import 'package:expense_manager/models/transaction.dart';
import 'package:expense_manager/widgets/cupertino_add_transaction.dart';
import 'package:expense_manager/widgets/chart.dart';
import 'package:expense_manager/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class CupertinoHomePage extends StatefulWidget {
  final Function changeTheme;
  final bool blueTheme;
  const CupertinoHomePage(
      {Key? key, required this.blueTheme, required this.changeTheme})
      : super(key: key);

  @override
  State<CupertinoHomePage> createState() => _CupertinoHomePageState();
}

class _CupertinoHomePageState extends State<CupertinoHomePage> {
  int globalId = 0;
  List<Transaction> _userTransactions = [
    //Transaction(id: 3, amount: 299.99, title: "Phone", date: DateTime.now()),
    //Transaction(id: 4, amount: 399.99, title: "Computer", date: DateTime.now()),
  ];

  File? _file;
  static const _fileName = 'transctions.json';

  Future<File> _initFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/$_fileName');
  }

  Future<File> get file async {
    if (_file != null) {
      return _file!;
    }
    _file = await _initFile();
    return _file!;
  }

  void saveTransactions() async {
    final File fl = await file;
    final txListMap = _userTransactions
        .map(
          (e) => e.toJson(),
        )
        .toList();
    await fl.writeAsString(jsonEncode(txListMap));
  }

  void loadTransactions() async {
    final File fl = await file;
    final content = await fl.readAsString();

    final List<dynamic> jsonData = jsonDecode(content);
    final List<Transaction> transactions = jsonData
        .map(
          (e) => Transaction.fromJson(e as Map<String, dynamic>),
        )
        .toList();
    setState(() {
      _userTransactions = transactions;
    });
  }

  void _deleteTransaction(int id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _addTransaction(String title, String amountString, DateTime trxDate) {
    title = title == "" ? "Anonymous" : title;
    double amount = double.tryParse(amountString) == null
        ? 0.0
        : double.parse(amountString);
    amount = amount < 0 ? 0.0 : amount;
    Transaction tx = Transaction(
      id: ++globalId,
      title: title,
      amount: amount,
      date: trxDate,
    );

    setState(
      () {
        _userTransactions.add(tx);
      },
    );
  }

  void showModalForm(BuildContext ctx) {
    showCupertinoModalPopup(
      context: ctx,
      builder: (context) {
        return CupertinoAddTransaction(
          addTransaction: _addTransaction,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var appBarWidget = CupertinoNavigationBar(
      middle: const Text("Expense Manager"),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: CupertinoButton(
              onPressed: saveTransactions,
              child: const Icon(CupertinoIcons.floppy_disk),
            ),
          ),
          FittedBox(
            child: CupertinoButton(
              onPressed: loadTransactions,
              child: const Icon(CupertinoIcons.cloud_download_fill),
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: CupertinoButton(
              onPressed: () => showModalForm(context),
              child: const Icon(CupertinoIcons.add),
            ),
          ),
          FittedBox(
            child: CupertinoSwitch(
              value: widget.blueTheme,
              thumbColor: CupertinoTheme.of(context).primaryColor,
              trackColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
              onChanged: (val) {
                widget.changeTheme(val);
              },
            ),
          )
        ],
      ),
    );
    return CupertinoPageScaffold(
      navigationBar: appBarWidget,
      child: SafeArea(
        child: SingleChildScrollView(
          child: (mediaQuery.orientation == Orientation.portrait)
              ? Column(
                  children: [
                    SizedBox(
                      height: (mediaQuery.size.height -
                              appBarWidget.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.3,
                      child: Chart(
                        userTransactions: _userTransactions,
                      ),
                    ),
                    SizedBox(
                      height: (mediaQuery.size.height -
                              appBarWidget.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: TransactionList(
                          userTransactions: _userTransactions,
                          delTrx: _deleteTransaction),
                    ),
                  ],
                )
              : Row(
                  children: [
                    SizedBox(
                      height: (mediaQuery.size.height -
                          appBarWidget.preferredSize.height -
                          mediaQuery.padding.top),
                      width: mediaQuery.size.width * 0.5,
                      child: Chart(
                        userTransactions: _userTransactions,
                      ),
                    ),
                    SizedBox(
                      height: (mediaQuery.size.height -
                          appBarWidget.preferredSize.height -
                          mediaQuery.padding.top),
                      width: mediaQuery.size.width * 0.5,
                      child: TransactionList(
                          userTransactions: _userTransactions,
                          delTrx: _deleteTransaction),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
