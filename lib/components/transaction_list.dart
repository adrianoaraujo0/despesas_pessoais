import 'package:despesas_pessoais/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({required this.transactions, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: transactions.isEmpty ? 
      Column(children:[
        const SizedBox(height: 20),
        Text(
          "Nenhuma Transacao Cadastrada!",
          style: Theme.of(context).textTheme.headline6,
          ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: Image.asset(
            "assets/images/waiting.png",
            fit:  BoxFit.cover,
            )
          )
        ])
      : ListView.builder(
        shrinkWrap: true,
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
            return Card(
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Theme.of(context).colorScheme.primary)),
                  child: Text("\$${transaction.value.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 20, color: Colors.purple,
                  fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: Theme.of(context).textTheme.headline6),
                    Text(
                      DateFormat("d MMM y").format(transaction.date),
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
