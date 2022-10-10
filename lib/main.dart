import 'dart:math';

import 'package:despesas_pessoais/components/transaction_form.dart';
import 'package:despesas_pessoais/components/transaction_list.dart';
import 'package:despesas_pessoais/components/transaction_user.dart';
import 'package:despesas_pessoais/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
 const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final transactions = [
    Transaction(id: "t1", title: "Tenis", value: 500, date: DateTime.now()),
    Transaction(id: "t2", title: "Conta de luz", value: 211, date: DateTime.now()),
    Transaction(id: "t2", title: "Conta de luz", value: 211, date: DateTime.now()),
  ];

  void openTransactionFormModal(BuildContext context){
    showModalBottomSheet(context: context, builder: ((_) {
      return TransactionForm(onSubmitted: addTransaction);
    }));
  }

   void addTransaction(String title, double value) {
    final newTransaction = Transaction(
        id: Random().nextDouble().toString(),
        title: title,
        value: value,
        date: DateTime.now());

    setState(() {
      transactions.add(newTransaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Despesas Pessoais"), actions: [IconButton(onPressed: (() => openTransactionFormModal(context)), icon: const Icon(Icons.add))],),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [  
              const SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.blue,
                  elevation: 5,
                  child: Text("Gráfico"),
                ),
              ),
              TransactionList(transactions: transactions),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => openTransactionFormModal(context), child: const Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
