import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import '../../model/expenses.dart';

class ExpensesController{
  final List<Expenses> transactions = [];
  DateTime selectedDate = DateTime.now();

  final MoneyMaskedTextController valueController = MoneyMaskedTextController(precision: 2, leftSymbol: 'R\$ ');
  final TextEditingController titleController = TextEditingController();

  final BehaviorSubject<List<Expenses>> updateTransactionsList = BehaviorSubject<List<Expenses>>();
  final BehaviorSubject<DateTime> updateDateForm = BehaviorSubject<DateTime>();
  final BehaviorSubject<bool> updateChart = BehaviorSubject<bool>();
  double accumulate = 0 ;
  
  void openTransactionFormModal(BuildContext context, Widget form) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return form;
      },
    );
  }

  void addTransaction(BuildContext context) {
    if(valueController.text.isEmpty || titleController.text.isEmpty)return;

    final Expenses newTransaction = Expenses(
      Random().nextInt(100),
      titleController.text,
      valueController.numberValue,
      selectedDate
    );
    
    transactions.add(newTransaction);

    updateTransactionsList.sink.add(transactions);

    titleController.clear();
    valueController.updateValue(0);
    selectedDate = DateTime.now();
    
    Navigator.of(context).pop();
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

   void removeTransaction(int id, BuildContext context){
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
                  transactions.removeWhere((element) => element.id == id);
                  updateTransactionsList.sink.add(transactions);
                  updateChart.sink.add(true);
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
    List<Expenses> dayTransactions = transactions.where((element) => element.date!.day == day).toList();

    if(dayTransactions.isNotEmpty){
      accumulate = dayTransactions.map((transactions) =>  transactions.value).reduce((value, element) => value! + element!)!;
      return accumulate;
    }
    return 0.0;
  }

  SideTitles bottomTitles () {
    return SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        return Text("${value.toStringAsFixed(0)}/${selectedDate.month}", style: const TextStyle(fontWeight: FontWeight.w500));
      } 
    );
  }

  List<BarChartGroupData> chartGroup(){
     return [
      BarChartGroupData(
        x: selectedDate.day - 6,
        barRods: [BarChartRodData(toY:  accumulateDateValues(selectedDate.day - 6)/100, width: 10)] 
      ),
      BarChartGroupData(
        x: selectedDate.day - 5,
        barRods: [BarChartRodData(toY:  accumulateDateValues(selectedDate.day - 5)/100, width: 10)] 
      ),
      BarChartGroupData(
        x: selectedDate.day - 4,
        barRods: [BarChartRodData(toY:  accumulateDateValues(selectedDate.day - 4)/100, width: 10)] 
      ),
      BarChartGroupData(
        x: selectedDate.day - 3,
        barRods: [BarChartRodData(toY:  accumulateDateValues(selectedDate.day - 3)/100, width: 10)] 
      ),
      BarChartGroupData(
        x: selectedDate.day - 2,
        barRods: [BarChartRodData(toY: accumulateDateValues(selectedDate.day - 2)/100, width: 10)] 
      ),
      BarChartGroupData(
        x: selectedDate.day - 1,
        barRods: [BarChartRodData(toY: accumulateDateValues(selectedDate.day - 1)/100, width: 10)] 
      ),
      BarChartGroupData(
        x: selectedDate.day,
        barRods: [BarChartRodData(toY: accumulateDateValues(selectedDate.day)/100, width: 10)] 
      ),
    ];  
  }

}

