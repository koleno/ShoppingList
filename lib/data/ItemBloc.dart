import 'dart:async';

import 'package:shoppinglist/data/ItemDao.dart';

import 'Item.dart';

class ItemBloc {
  final _itemDao = ItemDao();
  final _itemController = StreamController<List<Item>>.broadcast();
  get items => _itemController.stream;

  ItemBloc() {
    getItems();
  }

  getItems() async {
    _itemController.sink.add(await _itemDao.getItems());
  }

  deleteItem(Item item) async {
    await _itemDao.deleteItem(item);
    getItems();
  }

  addItem(Item item) async {
    await _itemDao.insertItem(item);
    getItems();
  }

  /// Switches item to checked / unchecked
  toggleItem(Item item) async {
    await _itemDao.updateItem(Item(id: item.id, checked: !item.checked, title: item.title));
    getItems();
  }

  close() {
    _itemController.close();
  }

}