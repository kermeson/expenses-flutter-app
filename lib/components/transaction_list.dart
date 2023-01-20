import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(
      {Key? key, required this.transactions, required this.onRemove})
      : super(key: key);

  final List<Transaction> transactions;
  final void Function(String) onRemove;

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Nenhuma Transação Cadastradaa!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Container(
                    height: constraints.maxHeight * 0.6,
                    padding: EdgeInsets.only(top: 10),
                    child: Image.asset('assets/images/waiting.png'))
              ],
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final e = transactions[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(child: Text('R\$${e.value}')),
                    ),
                  ),
                  title: Text(
                    e.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                    DateFormat('d MMM y').format(e.date),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () => onRemove(e.id),
                  ),
                ),
              );
            });
  }
}
