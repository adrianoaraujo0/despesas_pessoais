import 'package:despesas_pessoais/model/expenses.dart';
import 'package:despesas_pessoais/repository/columns.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

String expensesTable = "expensesTable";
Expense expenses = Expense();

class ExpensesHelper{ 
  
  static final ExpensesHelper _instance = ExpensesHelper.internal();

  factory ExpensesHelper()=> _instance;

  ExpensesHelper.internal();

  Database? _db;

  Columns columns = Columns();

  get db async{

    if(_db != null)return _db;

    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async{
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "expenses.db");
    
    return openDatabase(
      path,
      version: 1,
      onCreate: ((db, version)async {
        await db.execute(
          "CREATE TABLE $expensesTable(${columns.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT, ${columns.titleColumn} TEXT,"
          "${columns.valueColumn} REAL, ${columns.dateColumn} INT)"
        );
      })
    );
  }

  Future<Expense> saveExpense(Expense expenses)async {
    Database dbExpenses = await db;
    List<Expense> allExpenses = await getAllExpenses();
   
    expenses.id = await dbExpenses.insert(expensesTable, expenses.toMap());
    allExpenses.any((expense) => expense.id == expenses.id);
    return expenses;
  }

  Future<Expense> getExpenses(int id) async{
    Database dbExpenses = await db;
    List<Map> maps = await dbExpenses.query(
      expensesTable,
      columns: [columns.idColumn, columns.titleColumn, columns.valueColumn, columns.dateColumn],
      where: "${columns.idColumn} = ?",
      whereArgs: [id]
    );
    
     return Expense.fromMap(maps.first);
    // if(maps.isNotEmpty){
    //   return Expenses.fromMap(maps.first);
    // }else{
    //   return null;
    // }
  }

  Future<int> deleteExpenses(int id) async{
     Database dbExpenses = await db;
    
    return await dbExpenses.delete(expensesTable, where: "${columns.idColumn} = ?", whereArgs: [id]);
  }

  Future<int> updateExpenses(Expense expense) async{
    Database dbExpenses = await db;
    
    return await dbExpenses.update(
      expensesTable,
      expense.toMap(),
      where: "${columns.idColumn} = ?",
      whereArgs: [expense.id]
    );
  }

  Future<List<Expense>> getAllExpenses() async{
    Database dbExpenses = await db;
    List listMap = await dbExpenses.rawQuery("SELECT *FROM $expensesTable");
    List<Expense> listExpenses = [];

    for(Map m in listMap){
      listExpenses.add(Expense.fromMap(m));
    }
    return listExpenses;
  }

  Future<int?> getNumber() async{
    Database dbExpenses = await db;

    return Sqflite.firstIntValue(await dbExpenses.rawQuery("SELECT COUNT(*) FROM $expensesTable"));
  }

   close()async{
    Database dbExpanses = db;
    dbExpanses.close();
  }


}


