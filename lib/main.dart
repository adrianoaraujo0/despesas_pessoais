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
      appBar: AppBar(title: const Text("Despesas Pessoais")),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: double.infinity,
              child: const Card(
                color: Colors.blue,
                elevation: 5,
                child: Text("Gráfico"),
              ),
            ),
            Column(
              children: transactions.map((e) {
                return Card(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.purple),
                        ),
                        child: Text(
                          "\$${e.value.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.purple,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.title,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${e.date}",
                            style: const TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
