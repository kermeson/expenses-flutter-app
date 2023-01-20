import 'dart:math';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/transaction.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();
    return MaterialApp(
      home: MyHomePage(),
      theme: tema.copyWith(
          colorScheme: tema.colorScheme.copyWith(
            primary: Color.fromARGB(255, 73, 39, 176),
            secondary: Colors.amber,
          ),
          textTheme: tema.textTheme.copyWith(
              headline6: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              button: const TextStyle(
                color: Colors.white,
              ))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get recentTransactions {
    return _transactions
        .where((transaction) => transaction.date
            .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .toList();
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR');

    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    var appBar2 = AppBar(
      title: Text(
        'Despesas Pessoais',
        style: TextStyle(
          fontFamily: 'OpenSans',
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      actions: [
        IconButton(
          onPressed: () => _openTransactionFormModal(context),
          icon: Icon(Icons.add),
        )
      ],
    );

    final avaliableHeigth =
        MediaQuery.of(context).size.height - (appBar2.preferredSize.height);

    return Scaffold(
        appBar: appBar2,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Exibir Gráfico'),
                    Switch(
                        value: _showChart,
                        onChanged: (value) {
                          setState(() {
                            _showChart = value;
                          });
                        }),
                  ],
                ),
              if (_showChart || !isLandscape)
                Container(
                  height: avaliableHeigth * (isLandscape ? 0.7 : 0.3),
                  child: Card(
                    child: Chart(recentTransactions: recentTransactions),
                  ),
                ),
              if (!_showChart || !isLandscape)
                Container(
                  height: avaliableHeigth * 0.7,
                  child: TransactionList(
                    transactions: _transactions,
                    onRemove: _deleteTransaction,
                  ),
                )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openTransactionFormModal(context),
          backgroundColor: Theme.of(context).colorScheme.primary,
          splashColor: Colors.red,
          focusColor: Colors.blue,
          hoverColor: Color.fromARGB(255, 82, 218, 255),
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
