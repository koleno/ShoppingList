import 'dart:async';

import 'package:shoppinglist/data/ItemDao.dart';

import 'Item.dart';

class ShoppingListBloc {
  final _itemDao = ItemDao();
  final _itemController = StreamController<List<Item>>.broadcast();
  final _actionsController = StreamController<bool>.broadcast();
  get items => _itemController.stream;
  get hasActions => _actionsController.stream;

  ShoppingListBloc() {
    getItems();
  }

  getItems() async {
    List<Item> itemsList = await _itemDao.getItems();
    _actionsController.sink.add(itemsList.isNotEmpty);
    _itemController.sink.add(itemsList);
  }

  deleteItem(Item item) async {
    await _itemDao.deleteItem(item);
    getItems();
  }

  addItem(Item item) async {
    await _itemDao.insertItem(item);
    getItems();
  }

  deleteAllItems() async {
    await _itemDao.deleteAllItems();
    getItems();
  }

  /// Switches item to checked / unchecked
  toggleItem(Item item) async {
    await _itemDao.updateItem(Item(id: item.id, checked: !item.checked, title: item.title));
    getItems();
  }

  close() {
    _itemController.close();
    _actionsController.close();
  }

}