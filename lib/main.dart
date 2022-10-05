import 'package:despesas_pessoais/models/transaction.dart';
import 'package:flutter/material.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final transactions = [
    Transaction(id: "t1", title: "Tenis", value: 500, date: DateTime.now()),
    Transaction(
        id: "t2", title: "Conta de luz", value: 211, date: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Despesas Pessoais"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: double.infinity,
              child: const Card(
                color: Colors.blue,
                child: const Text("Gráfico"),
                elevation: 5,
              ),
            ),
            Column(
              children: transactions.map((e) {
                return Card(
                  child: Text(e.title),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
