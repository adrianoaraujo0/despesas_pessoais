import 'package:despesas_pessoais/model/expenses.dart';
import 'package:despesas_pessoais/ui/tela_dashboard_resultado/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListaTransacoes extends StatefulWidget {
   ListaTransacoes({super.key});

  @override
  State<ListaTransacoes> createState() => _ListaTransacoesState();
}

class _ListaTransacoesState extends State<ListaTransacoes> {

    @override
  void initState() {   
    dashboardController.getExpenses();
    super.initState();
  }


  DashboardController dashboardController = DashboardController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Expense>>(
      stream: dashboardController.updateExpensesList.stream,
      builder: (context, snapshot) {
        if(snapshot.data == null || snapshot.data!.isEmpty){
          return const CircularProgressIndicator();
        }else{
           return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                expandedHeight: 160,
                flexibleSpace: FlexibleSpaceBar(title: Text("R\$ ${dashboardController.transactionsTotalSum()}"), titlePadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
                )
              ];
            },
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 11,
                    itemBuilder: (context, index) {
                      return ListTile(
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
                      );
                    },
                  ),
                ]
              ),
            ),
          ),
        );
        }
       
      }
    );
  }
}