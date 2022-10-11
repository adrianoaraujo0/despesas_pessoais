import 'package:flutter/material.dart';

class TransactionForm extends StatelessWidget {
  final TextEditingController valueController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  void Function(String, double) onSubmitted;

  TransactionForm({required this.onSubmitted, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: "Título"),
          ),
          TextField(
            controller: valueController,
            decoration: const InputDecoration(labelText: "Valor(R\$)"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {onSubmitted(titleController.text, double.parse(valueController.text));},
                  child: const Text("Nova transação", style: TextStyle(color: Colors.purple),)),
            ],
          )
        ],
      ),
    );
  }
}
