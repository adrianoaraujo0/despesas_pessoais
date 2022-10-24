import 'package:despesas_pessoais/repository/expenses_helper.dart';
import 'package:despesas_pessoais/repository/expenses_helper.dart';
import 'package:despesas_pessoais/repository/expenses_helper.dart';
import 'package:despesas_pessoais/repository/expenses_helper.dart';
import 'package:despesas_pessoais/ui/tela_dashboard_resultado/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'model/expenses.dart';
 
main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await ExpensesHelper().db;
  runApp(ExpensesApp());
}
 
class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();
 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.green,
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
  State<MyHomePage> createState() => _MyHomePageState();
  
}

class _MyHomePageState extends State<MyHomePage> {

    ExpensesHelper expensesHelper = ExpensesHelper();
  @override
  void initState() {
    
    expensesHelper.getAllExpenses().then((value) => print(value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPage(spendingLimit: 1000);
  }
}
