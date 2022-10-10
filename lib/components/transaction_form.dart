import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  TransactionForm({required this.onSubmitted, super.key});

  void Function(String, double) onSubmitted;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController valueController = TextEditingController();

  final TextEditingController titleController = TextEditingController();

  submitForm(){
    if(valueController.text.isEmpty || titleController.text.isEmpty){
      return;
      }

    widget.onSubmitted(titleController.text, double.parse(valueController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: "Título"),
            onSubmitted: (_) => submitForm(),
          ),
          TextField(
            controller: valueController,
            decoration: const InputDecoration(labelText: "Valor(R\$)"),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onSubmitted: (_) => submitForm(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: submitForm,
                  child: const Text(
                    "Nova transação",
                    style: TextStyle(color: Colors.purple),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
