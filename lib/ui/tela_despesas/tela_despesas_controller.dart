import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import '../../models/transaction.dart';

class TelaDespesasController{
  BehaviorSubject<bool> updateList = BehaviorSubject<bool>();
  final List<Transaction> transactions = [];
  DateTime selectedDate = DateTime.now();

    void openTransactionFormModal(BuildContext context, Widget form) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return form;
      },
    );
  }

  void addTransaction(String title, double value, DateTime dateTime, BuildContext context) {
     if(value == 0 || title.isEmpty ){return;}

    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: dateTime
    );
 
    transactions.add(newTransaction);

    Navigator.of(context).pop();
  }

  buildShowDatePicker(BuildContext context) async{
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now()
    )
    .then(((pickedDate){
          if(pickedDate == null){return;}
          print(pickedDate);
        }
      ));
  }
  
}