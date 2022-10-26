import 'dart:math';
import 'package:despesas_pessoais/model/chart_expense.dart';
import 'package:despesas_pessoais/repository/expenses_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:rxdart/subjects.dart';
import '../../model/expenses.dart';

class DashboardController{
  List<Expense> listExpenses = [];
  DateTime selectedDate = DateTime.now();

  final MoneyMaskedTextController valueController = MoneyMaskedTextController(precision: 2, leftSymbol: 'R\$ ');
  final TextEditingController titleController = TextEditingController();

  final BehaviorSubject<List<Expense>> updateExpensesList = BehaviorSubject<List<Expense>>();
  final BehaviorSubject<DateTime> updateDateForm = BehaviorSubject<DateTime>();
  final BehaviorSubject<List<Expense>>  updateBarChart = BehaviorSubject<List<Expense>>();
  final BehaviorSubject<List<ChartExpense>>  updateLineChart = BehaviorSubject<List<ChartExpense>>();
  
  double accumulate = 0 ;

  ExpensesHelper expensesHelper = ExpensesHelper();
  
  void openTransactionFormModal(BuildContext context, Widget form) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return form;
      },
    );
  }

  void getExpenses() async{
    listExpenses = await expensesHelper.getAllExpenses(); 
    updateExpensesList.sink.add(listExpenses.reversed.toList());
    updateBarChart.sink.add(listExpenses);
    updateLineChart.sink.add(listChart());
 }

  Future<List<Expense>> getAllExpenses() async{
    listExpenses = await expensesHelper.getAllExpenses(); 
    return listExpenses;

  }

  void addExpense(BuildContext context) {
    if(valueController.text.isEmpty || titleController.text.isEmpty)return;

    final Expense newExpense = Expense(
      title: titleController.text,
      value: valueController.numberValue,
      date: selectedDate
    );
    
    listExpenses.add(newExpense);
    expensesHelper.saveExpense(newExpense);

    titleController.clear();
    valueController.updateValue(0);
    selectedDate = DateTime.now();

    updateExpensesList.sink.add(listExpenses);
    updateBarChart.sink.add(listExpenses);
    updateLineChart.sink.add(listChart());
    Navigator.of(context).pop();
  }

  void editExpense(Expense expense) async{
    expensesHelper.updateExpenses(expense);
  }

  void buildShowDatePicker(BuildContext context) async{
    
    DateTime? time = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now()
    );
    if(time != null) selectedDate = time;
    updateDateForm.sink.add(selectedDate);
  }

   void removeExpense(int id, BuildContext context){
    showDialog(
      context: context, 
      builder: (BuildContext context) => SimpleDialog(
        alignment: Alignment.center,
        children: [
          const Text("ATENÇÃO", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10,),
          const Text("Tem certeza que deseja apagar essa despesa?", textAlign: TextAlign.center),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(onTap: () => Navigator.pop(context), child: Container(width: 60, height: 40, alignment: Alignment.center, child: const Text("NÃO", textAlign: TextAlign.center,))),
              const SizedBox(height: 10,),
              InkWell(
                onTap: () {
                  expensesHelper.deleteExpenses(id);
                  
                  Navigator.pop(context);
                  Navigator.pop(context);
                }, 
                child: Container(width: 60, height: 40, alignment: Alignment.center, child: const Text("SIM", textAlign: TextAlign.center,))
              )
            ],
          ),
        ],
      )
    );
  }
  
  double accumulateDateValues(int day){
    List<Expense> dayTransactions = listExpenses.where((element) => element.date!.day == day).toList();

    if(dayTransactions.isNotEmpty){
      accumulate = dayTransactions.map((transactions) =>  transactions.value).reduce((value, element) => value! + element!)!;
      return accumulate;
    }
    return 0.0;
  }

  SideTitles bottomTitles () {
    return SideTitles(
      showTitles: true,
      reservedSize: 20,
      getTitlesWidget: (value, meta) {
        return Text("${value.toStringAsFixed(0)}/${selectedDate.month}", style: const TextStyle(fontWeight: FontWeight.w500));
      } 
    );
  }

  List<BarChartGroupData> chartGroup(){
     return [
      BarChartGroupData(
        x: selectedDate.day - 6,
        barRods: [BarChartRodData(toY:accumulateDateValues(selectedDate.day - 6), width:10, borderRadius: BorderRadius.circular(2), color: Colors.green)] 
      ),
      BarChartGroupData(
        x: selectedDate.day - 5,
        barRods: [BarChartRodData(toY:accumulateDateValues(selectedDate.day - 5), width:10, borderRadius: BorderRadius.circular(2), color: Colors.green)] 
      ),
      BarChartGroupData(
        x: selectedDate.day - 4,
        barRods: [BarChartRodData(toY:accumulateDateValues(selectedDate.day - 4), width:10, borderRadius: BorderRadius.circular(2), color: Colors.green)] 
      ),
      BarChartGroupData(
        x: selectedDate.day - 3,
        barRods: [BarChartRodData(toY:accumulateDateValues(selectedDate.day - 3), width:10, borderRadius: BorderRadius.circular(2), color: Colors.green)] 
      ),
      BarChartGroupData(
        x: selectedDate.day - 2,
        barRods: [BarChartRodData(toY:accumulateDateValues(selectedDate.day - 2), width:10, borderRadius: BorderRadius.circular(2), color: Colors.green)] 
      ),
      BarChartGroupData(
        x: selectedDate.day - 1,
        barRods: [BarChartRodData(toY:accumulateDateValues(selectedDate.day - 1), width:10, borderRadius: BorderRadius.circular(2), color: Colors.green)] 
      ),
      BarChartGroupData(
        x: selectedDate.day,
        barRods: [BarChartRodData(toY:accumulateDateValues(selectedDate.day), width:10, borderRadius: BorderRadius.circular(2), color: Colors.green)] 
      ),
    ];  
  }

  double? transactionsTotalSum()=> listExpenses.map((expense) => expense.value ).reduce((value, element) => value! + element!);

  double? weeklyExpense() {
    List<Expense> week = listExpenses.where((expense) => expense.date!.day > selectedDate.day - 7).toList();
    return week.isNotEmpty ?  week.map((expense) => expense.value).reduce((value, element) => value! + element!) : 0;
  }
  
  double? monthlyExpense() {
    List<Expense> month = listExpenses.where((expense) => expense.date!.day > selectedDate.day - 30).toList();
    return month.isNotEmpty ? month.map((expense) => expense.value).reduce((value, element) => value! + element!) : 0;
  }
  
  double expensePerMonth(int month) {
    List<Expense> monthList = listExpenses.where((expense) => expense.date!.month == month).toList();
    return monthList.isNotEmpty ? monthList.map((expense) => expense.value).reduce((value, element) => value! + element!)! : 0;
  }

  List<ChartExpense> listChart(){
    List<String> months = ['Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'];
    List<ChartExpense> list = [];

    for(int i = 0; i<=11; i++){
      list.add(ChartExpense(month: months[i] , expenseMonth: expensePerMonth(i + 1)));
    }
    return list;
  } 
}
