import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import '../../model/transaction.dart';

class DespesasController{
  final List<Transaction> transactions = [];
  DateTime selectedDate = DateTime.now();

  final MoneyMaskedTextController valueController = MoneyMaskedTextController(precision: 2, leftSymbol: 'R\$ ');
  final TextEditingController titleController = TextEditingController();

  final BehaviorSubject<List<Transaction>> updateTransactionsList = BehaviorSubject<List<Transaction>>();
  final BehaviorSubject<DateTime> updateDateForm = BehaviorSubject<DateTime>();
  
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

    print(valueController.numberValue);
    
    final Transaction newTransaction = Transaction(
      id: Random().nextDouble(),
      title: titleController.text,
      value: valueController.numberValue,
      date: selectedDate
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

   void removeTransaction(double id, BuildContext context){
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
  


  }
