import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Item.dart';

class AppDb {
  static final AppDb appDb = AppDb();

  Database _db;

  Future<Database> get database async {
    if (_db != null) return _db;

    _db = await openDatabase(join(await getDatabasesPath(), "shopping_list.db"),
        onCreate: _onCreate, version: 1);

    return _db;
  }

  _onCreate(Database db, int version) {
    db.execute("CREATE TABLE Items ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "checked INTEGER,"
        "title TEXT)");
  }
}
