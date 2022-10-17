import 'package:despesas_pessoais/components/chart.dart';
import 'package:despesas_pessoais/ui/tela_despesas/despesas_page.dart';
import 'package:despesas_pessoais/ui/tela_gr%C3%A1fico/grafico_page.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import './components/transaction_form.dart';
import './components/transaction_list.dart';
import 'model/transaction.dart';
 
main() => runApp(ExpensesApp());
 
class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();
 
    return MaterialApp(
      home: MyHomePage(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.black,
        ),
        textTheme: tema.textTheme.copyWith(
          headline6: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
 
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
 
class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> transactions = [];

  List<Transaction> get recentTransactions{
    return transactions.where(
      (element){
        return element.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7)
      ));
     }
    ).toList();
  }
 

 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DespesasPage()
    );
  }
}
