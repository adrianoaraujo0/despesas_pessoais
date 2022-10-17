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

  List<Transaction> teste = [
    Transaction(id: 1, title: 'A', value: 10, date: DateTime.now()),
    Transaction(id: 2, title: 'A', value: 20, date: DateTime.now()),
    Transaction(id: 3, title: 'A', value: 3550, date: DateTime.now()),
    Transaction(id: 4, title: 'A', value: 400, date: DateTime.now()),
    Transaction(id: 5, title: 'A', value: 1000, date: DateTime.now()),
    Transaction(id: 6, title: 'A', value: 990, date: DateTime.now()),
    Transaction(id: 7, title: 'A', value: 70, date: DateTime.now()),
    Transaction(id: 9, title: 'A', value: 240, date: DateTime.now()),
    Transaction(id: 8, title: 'A', value: 2000, date: DateTime.now()),
    Transaction(id: 10, title: 'A', value: 20, date: DateTime.now()),
    Transaction(id: 11, title: 'A', value: 20, date: DateTime.now()),
  ];

   // LineChartData controla a aparência do gráfico 


    @override
  Widget build(BuildContext context) {
    return AspectRatio(
            aspectRatio: 2,
            child: BarChart(
              BarChartData(
                barGroups: chartGroup(),
                borderData:  FlBorderData(
                border: const Border(bottom: BorderSide(), left: BorderSide())),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
              )
            ),
          );
  }

  List<BarChartGroupData> chartGroup(){
    return teste.map((e) => 
      BarChartGroupData(x: e.id.toInt(),
      barRods: [BarChartRodData(toY: e.value)] 
      )
    ).toList();   
  }

   SideTitles get _bottomTitles => SideTitles(
    showTitles: true,
    getTitlesWidget: (value, meta) {
      String text = '';
      switch (value.toInt()) {
        case 0:
          text = 'Jan';
          break;
        case 2:
          text = 'Mar';
          break;
        case 4:
          text = 'May';
          break;
        case 6:
          text = 'Jul';
          break;
        case 8:
          text = 'Sep';
          break;
        case 10:
          text = 'Nov';
          break;
      }

      return Text(text);
    },
  );
//grafico de linhas
  // @override
  // Widget build(BuildContext context) {
  //   return LineChart(
  //     LineChartData(
  //       lineBarsData: [
  //         LineChartBarData(
  //           spots: teste.map((element) => FlSpot(element.id, element.value)).toList(),
  //         )
  //       ]
  //     ),
  //     swapAnimationCurve: Curves.linear,
  //   ) ;
  // }
}