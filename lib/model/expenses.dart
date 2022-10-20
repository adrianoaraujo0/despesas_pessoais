import 'package:despesas_pessoais/repository/columns.dart';

class Expenses {
  int? id;
  String? title;
  double? value;
  DateTime? date;
  
  Expenses([this.id, this.title, this.value, this.date]);
  Columns columns = Columns();

  Expenses.fromMap(Map map){
    id = map["idColumn"];
    title = map["titleColumn"];
    value = map["valueColumn"];
    date = map["dateColumn"];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      columns.titleColumn: title,
      columns.valueColumn: value,
      columns.dateColumn: date
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
