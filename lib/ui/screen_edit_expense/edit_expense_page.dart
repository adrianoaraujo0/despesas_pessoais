import 'package:despesas_pessoais/model/expenses.dart';
import 'package:despesas_pessoais/ui/tela_dashboard_resultado/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditExpensePage extends StatefulWidget {
  EditExpensePage({required this.expense, super.key});

  Expense expense;

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  DashboardController dashboardController = DashboardController();

  @override
  void initState() {
 

    dashboardController.titleController.text = widget.expense.title!;
    dashboardController.valueController.text = widget.expense.value!.toStringAsFixed(2).toString();
    dashboardController.selectedDate = widget.expense.date!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.expense.title}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => dashboardController.removeTransaction(widget.expense.id!, context)         
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: dashboardController.titleController,
              decoration: const InputDecoration(
                labelText: "Nome:"
              ),
            ),
            TextField(
              controller: dashboardController.valueController,
              decoration: const InputDecoration(
                labelText: "Valor:"
              ),
              keyboardType: const TextInputType.numberWithOptions(),
            ),
            SizedBox(
              height: 60,
              child: StreamBuilder<DateTime>(
              initialData: DateTime.now(),
              stream: dashboardController.updateDateForm.stream,
              builder: (context, snapshot) {
                return Row(
                  children: [
                    Expanded(child: Text("Data selecionada: ${DateFormat("dd/MM/y").format(snapshot.data!)}")),
                    TextButton(
                      onPressed: (){dashboardController.buildShowDatePicker(context);}, 
                      child: const Text("Selecionar data", 
                      style: TextStyle(fontWeight: FontWeight.w700))
                    ),
                  ],
                );
              }
              ),
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.expense.title = dashboardController.titleController.text;
          widget.expense.value = dashboardController.valueController.numberValue;
          widget.expense.date = dashboardController.selectedDate;
          dashboardController.editExpense(widget.expense);
          
          Navigator.pop(context);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.edit),
        ),
    );
  }
}