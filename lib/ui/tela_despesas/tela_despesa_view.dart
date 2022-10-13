import 'package:despesas_pessoais/models/transaction.dart';
import 'package:despesas_pessoais/ui/tela_despesas/tela_despesas_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TelaDespesas extends StatelessWidget {
  TelaDespesas({super.key});

  TelaDespesasController telaDespesasController = TelaDespesasController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas Pessoais')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildListTransactions(context)
          ],
        ),
      ),
      floatingActionButton: Container(     
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(backgroundColor: Colors.purple , child: const Icon(Icons.add), onPressed: () {
          telaDespesasController.openTransactionFormModal(context, buildForm(context));
          })
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }


  Widget buildForm(BuildContext context){
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
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          SizedBox(
            height: 70,
            child: Row(
              children: [
                 Expanded(
                   child: Text("Data selecionada: ${DateFormat("dd/MM/y").format(telaDespesasController.selectedDate)}"
                    ),
                 ),
                TextButton(
                  onPressed: (){telaDespesasController.buildShowDatePicker(context);}, 
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
                  onPressed: (){telaDespesasController.addTransaction(titleController.text, double.parse(valueController.text), telaDespesasController.selectedDate, context);},
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

  Widget buildListTransactions(BuildContext context){
    return StreamBuilder<bool>(
      stream: telaDespesasController.updateList.stream,
      builder: (context, snapshot) {
        return SizedBox(
          height: 300,
          child: telaDespesasController.transactions.isEmpty ? 
          Column(children:[
            const SizedBox(height: 20),
            Text(
              "Nenhuma Transacao Cadastrada!",
              style: Theme.of(context).textTheme.headline6,
              ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Image.asset(
                "assets/images/waiting.png",
                fit:  BoxFit.cover,
                )
              )
           ])
          : ListView.builder(
            shrinkWrap: true,
            itemCount: telaDespesasController.transactions.length,
            itemBuilder: (context, index) {
              final transaction = telaDespesasController.transactions[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text("R\$${transaction.value}")
                        ),
                      ),
                    ),
                    title: Text(
                      transaction.title, 
                      style: Theme.of(context).textTheme.headline6
                    ),
                    subtitle: Text(DateFormat('d MMM y').format(transaction.date)),
                    trailing: IconButton(
                      color: Theme.of(context).errorColor,
                      icon: const Icon(Icons.delete),
                      onPressed: (){
                        // removeTransaction(transaction.id);
                      }),
                  ),
                );
            },
          ),
        );
      }
    );

  }

}