import 'dart:math';
import 'package:despesas_pessoais/model/transaction.dart';
import 'package:despesas_pessoais/ui/tela_despesas/despesas_controller.dart';
import 'package:despesas_pessoais/ui/tela_gr%C3%A1fico/grafico_controller.dart';
import 'package:despesas_pessoais/ui/tela_gr%C3%A1fico/grafico_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DespesasPage extends StatelessWidget {
  DespesasPage({super.key});

  final DespesasController telaDespesasController = DespesasController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Despesas Pessoais')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
        child: Column(
          children: [
            barChart(),
            buildListTransactions(context),
          ],
        ),
      ),
      floatingActionButton: adicionarDespesa(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
  
  Widget barChart(){
    return StreamBuilder<bool>(
      stream: telaDespesasController.updateChart.stream,
      builder: (context, snapshot) {
        return SizedBox(
          height: 200,
          child:Card(
            elevation: 5,
            child: AspectRatio(
              aspectRatio: 2,
              child: BarChart(
                BarChartData(
                  minY: 0,
                  maxY: 10,
                  groupsSpace: 2,
                  barGroups: telaDespesasController.chartGroup(),
                  borderData:  FlBorderData(
                  border: const Border(bottom: BorderSide())),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(sideTitles: telaDespesasController.bottomTitles()),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                )
              )
            ),
          ), 
        );
      } 
    );
 }

  Widget adicionarDespesa(BuildContext context) {
    return Container(     
      margin: const EdgeInsets.only(bottom: 20),
      child: FloatingActionButton(
        onPressed: () => showModalBottomSheet(context: context, builder: (_) => buildForm(context)),
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      )
    );
  }

  Widget buildForm(BuildContext context){
    return Card(
      child: Column(
        children: [
          TextField(
            controller: telaDespesasController.titleController,
            decoration: const InputDecoration(labelText: "Título"),
          ),
          TextField(
            controller: telaDespesasController.valueController,
            decoration: const InputDecoration(labelText: "Valor(R\$)"),
            keyboardType: const TextInputType.numberWithOptions(),
          ),
          SizedBox(
            height: 70,
            child: StreamBuilder<DateTime>(
              initialData: DateTime.now(),
              stream: telaDespesasController.updateDateForm.stream,
              builder: (context, snapshot) {
                return Row(
                  children: [
                     Expanded(child: Text("Data selecionada: ${DateFormat("dd/MM/y").format(snapshot.data!)}")),
                     TextButton(
                        onPressed: (){telaDespesasController.buildShowDatePicker(context);}, 
                        child: const Text("Selecionar data", 
                        style: TextStyle(fontWeight: FontWeight.w700))
                      ),
                  ],
                );
              }
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: (){
                    telaDespesasController.addTransaction(context);
                    telaDespesasController.updateChart.sink.add(false);
                  },
                  child: const Text("Nova transação", style: TextStyle(color: Colors.white))
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildListTransactions(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<List<Transaction>>(
            stream: telaDespesasController.updateTransactionsList.stream,
            builder: (context, snapshot) {
              return SizedBox(
                height: 300,
                child: snapshot.data == null || snapshot.data!.isEmpty ? 
                Column(children:[
                  const SizedBox(height: 20),
                  Text("Nenhuma Despesa Cadastrada!", style: Theme.of(context).textTheme.headline6),
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
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.all(6),
                            child: FittedBox(child: Text('${snapshot.data![index].value}')),
                          ),
                          title: Text(snapshot.data![index].title, style: Theme.of(context).textTheme.headline6),
                          subtitle: Text(DateFormat('d MMM y').format(snapshot.data![index].date)),
                          trailing: IconButton(
                            color: Theme.of(context).errorColor,
                            icon: const Icon(Icons.delete),
                            onPressed: (){
                              telaDespesasController.removeTransaction(snapshot.data![index].id, context);
                            }
                          ),
                        ),
                      );
                  },
                ),
              );
            }
          ),
        ],
      ),
    );
  }
  


}