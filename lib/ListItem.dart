import 'package:flutter/material.dart';

import 'data/Item.dart';

class ListItem extends StatelessWidget {
  final Item item;
  final ValueChanged<Item> onChanged;

  ListItem(this.item, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Theme.of(context).buttonColor, width: 1.0))),
        child: Row(children: [
          Checkbox(
              onChanged: (bool value) {
                onChanged(item);
              },
              value: item.checked),
          Expanded(
              child: GestureDetector(
                  onTap: () {
                    onChanged(item);
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        item.title,
                        style: item.checked
                            ? TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 17)
                            : TextStyle(fontSize: 17),
                      ))))
        ]));
  }
}
