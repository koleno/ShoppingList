import 'package:shoppinglist/data/AppDb.dart';
import 'package:sqflite/sqflite.dart';

import 'Item.dart';

class ItemDao {
  final appDb = AppDb.appDb;

  Future<void> insertItem(Item item) async {
    final db = await appDb.database;

    await db.insert(
      "Items",
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateItem(Item item) async {
    final db = await appDb.database;
    await db
        .update("Items", item.toMap(), where: "id = ?", whereArgs: [item.id]);
  }

  Future<void> deleteItem(Item item) async {
    final db = await appDb.database;
    await db.delete("Items", where: "id = ?", whereArgs: [item.id]);
  }

  Future<void> deleteAllItems() async {
    final db = await appDb.database;
    await db.delete("Items");
  }

  Future<List<Item>> getItems() async {
    final db = await appDb.database;
    final List<Map<String, dynamic>> maps = await db.query("Items");

    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i]['id'],
        checked: maps[i]['checked'] == 0 ? false : true,
        title: maps[i]['title'],
      );
    });
  }
}
