import 'package:despesas_pessoais/repository/columns.dart';

class Expense {
  int? id;
  String? title;
  double? value;
  DateTime? date;
  
  Expense([this.id, this.title, this.value, this.date]);
  Columns columns = Columns();
 
  Expense.fromMap(Map map){
    DateTime convertMillisecondsToDateTime = DateTime.fromMillisecondsSinceEpoch(map["dateColumn"] );

    id = map["idColumn"];
    title = map["titleColumn"];
    value = map["valueColumn"];
    date = convertMillisecondsToDateTime;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      columns.titleColumn: title,
      columns.valueColumn: value,
      'dateColumn': date!.millisecondsSinceEpoch
    };
    if(id != null){
      map[columns.idColumn] = id;
    }

    return map;
  }

  String toString(){
    return "Expenses: id: $id, title: $title, value: $value, date: $date";
  }
}
