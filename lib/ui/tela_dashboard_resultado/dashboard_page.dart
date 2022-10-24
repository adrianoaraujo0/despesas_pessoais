import 'package:despesas_pessoais/model/expenses.dart';
import 'package:despesas_pessoais/ui/screen_edit_expense/edit_expense_page.dart';
import 'package:despesas_pessoais/ui/tela_dashboard_resultado/dashboard_controller.dart';
import 'package:despesas_pessoais/ui/tela_lista_transacoes/lista_transacoes_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({required this.spendingLimit ,super.key});
  double spendingLimit;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  final DashboardController dashboardController = DashboardController();

  @override
  void initState() {
    
    dashboardController.getExpenses();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Despesas Pessoais')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
          child: Column(
            children: [
              barChart(),
              buildListTransactions(context),
              pieChart()
            ],
          ),
        ),
      ),
      floatingActionButton: adicionarDespesa(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget barChart(){
    return StreamBuilder<List<Expense>>(
      stream: dashboardController.updateChart.stream,
      builder: (context, snapshot) {
        return SizedBox(
          height: 267,
          width: 400,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Text("Gasto semanal", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  child: Text("Total: "),
                ),
                AspectRatio(
                  aspectRatio: 2,
                  child: BarChart(
                    BarChartData(
                      backgroundColor: Colors.white,
                      minY: 0,
                      maxY: widget.spendingLimit,
                      barGroups: dashboardController.chartGroup(),
                      borderData:  FlBorderData(
                      show: true,
                      border: const Border(bottom: BorderSide.none)),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(sideTitles: dashboardController.bottomTitles()),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                    )
                  )
                ),
              ],
            ),
          ),
        );
      } 
    );
 }

 Widget pieChart(){
  return SizedBox(
    height: 400,
    width: 400,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
            child: Text("Despesas mensal", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
          ),
        ]
      ),
    ),
  );
 }

  Widget adicionarDespesa(BuildContext context) {
    return Container(     
      margin: const EdgeInsets.only(bottom: 20),
      child: FloatingActionButton(
        onPressed: () => showModalBottomSheet(context: context, builder: (_) => buildForm(context)),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      )
    );
  }

  Widget buildForm(BuildContext context){
    return Card(
      child: Column(
        children: [
          TextField(
            controller: dashboardController.titleController,
            decoration: const InputDecoration(labelText: "Título"),
          ),
          TextField(
            controller: dashboardController.valueController,
            decoration: const InputDecoration(labelText: "Valor(R\$)"),
            keyboardType: const TextInputType.numberWithOptions(),
          ),
          SizedBox(
            height: 70,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: (){
                    dashboardController.addExpense(context);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StreamBuilder<List<Expense>>(
          stream: dashboardController.updateExpensesList.stream,
          initialData: const [],
          builder: (context, snapshot) {
            return SizedBox(
              height: 336,
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
              : Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                        child: Text("Últimas despesas", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.list),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListaTransacoes()))
                        ),
                      ],
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length < 5 ? snapshot.data!.length : 5,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (context) =>  EditExpensePage(expense: snapshot.data![index])));
                              dashboardController.getExpenses();
                            },
                            child: ListTile(
                              leading: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: CircleAvatar(),
                              ),
                              title: Text(snapshot.data![index].title!, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
                              trailing:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('R\$ ${snapshot.data![index].value}', style: const TextStyle(fontWeight: FontWeight.w500)),
                                  Text('${snapshot.data![index].date!.day}/${snapshot.data![index].date!.month}', style: const TextStyle(fontWeight: FontWeight.w300)),
                                ],
                              ),
                            ),
                          );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ],
    );
  }
}