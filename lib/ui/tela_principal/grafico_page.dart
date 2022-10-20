// import 'dart:math';

// import 'package:despesas_pessoais/model/transaction.dart';
// import 'package:despesas_pessoais/ui/tela_despesas/despesas_controller.dart';
// import 'package:despesas_pessoais/ui/tela_despesas/despesas_page.dart';
// import 'package:despesas_pessoais/ui/tela_gr%C3%A1fico/grafico_controller.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

// class GraficoPage extends StatefulWidget {
//   GraficoPage({super.key});

//   @override
//   State<GraficoPage> createState() => _GraficoPageState();
// }

// class _GraficoPageState extends State<GraficoPage> {
//   DespesasController despesasController = DespesasController();


//     @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 5,
//       child: AspectRatio(
//         aspectRatio: 2,
//         child: BarChart(
//           BarChartData(
//             groupsSpace: 10,
//             barGroups: despesasController.chartGroup(),
//             borderData:  FlBorderData(
//             border: const Border(bottom: BorderSide())),
//             gridData: FlGridData(show: false),
//             titlesData: FlTitlesData(
//               bottomTitles: AxisTitles(sideTitles: despesasController.bottomTitles()),
//               topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//               rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//               leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             ),
//           )
//         )
//       ),
//     );
//   }
// }