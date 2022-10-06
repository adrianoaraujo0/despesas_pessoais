import 'package:flutter/material.dart';

class TransactionForm extends StatelessWidget {
  final TextEditingController valueController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  TransactionForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: "Título"),
          ),
          TextField(
            controller: valueController,
            decoration: InputDecoration(labelText: "Valor(R\$)"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    print(titleController.text);
                    print(valueController.text);
                  },
                  child: Text(
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
