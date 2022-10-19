import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB{
  //Construtor com acesso privado
  DB._();
  //Criar uma instancia de DB
  static final DB instance = DB._();
  //Instancia do SQLite
  static Database? _database;

  get database async{
    if(_database != null)return _database;

    return await _initDatabase();
  }

  _initDatabase() async{
    return await openDatabase(
      join(await getDatabasesPath(), 'expenses.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, versao) async{
    await db.execute(_expenses);
  }

  String get _expenses => ''''
    CREATE TABLE expenses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      value TEXT,
      date INT
    );
  ''';

}