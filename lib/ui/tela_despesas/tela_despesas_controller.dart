import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import '../../model/transaction.dart';

class TelaDespesasController{
  final List<Transaction> transactions = [];
  DateTime selectedDate = DateTime.now();

  final TextEditingController valueController = TextEditingController();
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

    print(double.parse(valueController.text));

    final Transaction newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: titleController.text,
      value: 0,
      date: selectedDate
    );
    
    transactions.add(newTransaction);

    updateTransactionsList.sink.add(transactions);

    titleController.clear();
    valueController.clear();
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

   void removeTransaction(String id, BuildContext context){
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

