import 'package:despesas_pessoais/model/transaction.dart';
import 'package:despesas_pessoais/ui/tela_despesas/despesas_controller.dart';
import 'package:despesas_pessoais/ui/tela_despesas/despesas_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class GraficoPage extends StatelessWidget {
  GraficoPage({super.key});

  DespesasController despesasController = DespesasController();
      DateTime dateTimeNow = DateTime.now();
  List<Transaction> teste = [
    Transaction(id: 1, title: 'A', value: 1000, date: DateTime.parse('2022-10-17')),
    Transaction(id: 2, title: 'A', value: 2000, date: DateTime.parse('2022-10-17')),
    Transaction(id: 3, title: 'A', value: 3550, date: DateTime.parse('2022-10-15')),
    Transaction(id: 4, title: 'A', value: 1500, date: DateTime.parse('2022-10-14')),
    Transaction(id: 5, title: 'A', value: 1000, date: DateTime.parse('2022-10-13')),
    Transaction(id: 6, title: 'A', value: 990, date: DateTime.parse('2022-10-12')),
    Transaction(id: 7, title: 'A', value: 0, date: DateTime.parse('2022-10-11')),
  ];

    @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: AspectRatio(
        aspectRatio: 2,
        child: BarChart(
          BarChartData(
            groupsSpace: 10,
            barGroups: chartGroup(),
            borderData:  FlBorderData(
            border: const Border(bottom: BorderSide())),
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(sideTitles: bottomTitles()),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
          )
        ),
      ),
    );
  }

  List<BarChartGroupData> chartGroup(){
     return [
      BarChartGroupData(
        x: dateTimeNow.day,
        barRods: [BarChartRodData(toY: 2, width: 10)] 
      )
    ];  
    
  }
 
  SideTitles bottomTitles () {
    return SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        return Text("${value.toStringAsFixed(0)}/${dateTimeNow.month}", style: const TextStyle(fontWeight: FontWeight.w700));
      } 
    );
  }
}