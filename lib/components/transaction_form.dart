import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  TransactionForm({required this.onSubmitted, super.key});

  void Function(String, double, DateTime dateTime) onSubmitted;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController valueController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  submitForm(){
    if(valueController.text.isEmpty || titleController.text.isEmpty ){return;}

    widget.onSubmitted(titleController.text, double.parse(valueController.text), selectedDate);
  }

  buildShowDatePicker() async{
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now()
    ).then(((pickedDate){
          if(pickedDate == null){return;}
          setState(() {selectedDate = pickedDate;});
        }
      ));
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
          SizedBox(
            height: 70,
            child: Row(
              children: [
                 Expanded(
                   child: Text("Data selecionada: ${DateFormat("dd/MM/y").format(selectedDate)}"
                    ),
                 ),
                TextButton(
                  onPressed: (){buildShowDatePicker();}, 
                  child: const Text("Selecionar data", 
                  style: TextStyle(
                    fontWeight: FontWeight.w700
                  ),)
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: submitForm,
                  child: const Text(
                    "Nova transação",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          )
        ],
      ),
    );
  }
}