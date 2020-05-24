import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shoppinglist/data/ItemBloc.dart';

import 'data/Item.dart';
import 'ListItem.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String appTitle = "Shopping List";
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Georgia',
          brightness: Brightness.light,
          primarySwatch: Colors.red,
          accentColor: Colors.amber),
      home: ShoppingListPage(title: appTitle),
    );
  }
}

class ShoppingListPage extends StatefulWidget {
  ShoppingListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final ShoppingListBloc listBloc = ShoppingListBloc();

  void _handleChange(Item item) async {
    listBloc.toggleItem(item);
  }

  void _handleAdd(String title) async {
    listBloc.addItem(Item(checked: false, title: title));
  }

  void _handleDeleteAll() async {
    showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
                "Do you want to empty your shopping list?\n\nYou can also remove individual items by swiping them to sides."),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Delete"),
                onPressed: () {
                  listBloc.deleteAllItems();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _handleAddClicked() async {
    String title = "";

    showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(children: [
              Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(Icons.add_circle,
                      color: Theme.of(context).primaryColorDark)),
              Text("Add Item"),
            ]),
            content: TextField(
              autofocus: true,
              decoration: new InputDecoration(hintText: 'Milk, bread, ...'),
              onChanged: (value) {
                title = value;
              },
              onSubmitted: (value) {
                _handleAdd(value);
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Add"),
                onPressed: () {
                  _handleAdd(title);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _handleDismiss(Item item) async {
    listBloc.deleteItem(item);
  }

  Widget _getDeleteAction() {
    return IconButton(
      padding: EdgeInsets.all(10),
      icon: Icon(Icons.delete),
      onPressed: _handleDeleteAll,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          StreamBuilder(
            stream: listBloc.hasActions,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data != null && snapshot.data) {
                return _getDeleteAction();
              } else {
                return Container();
              }
            },
          )
        ],
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: listBloc.items,
        builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Item item = snapshot.data[index];
                  return Dismissible(
                      onDismissed: (direction) {
                        snapshot.data.remove(item);
                        _handleDismiss(item);
                      },
                      key: Key(item.id.toString()),
                      background:
                          Container(color: Theme.of(context).primaryColorDark),
                      child: ListItem(item, _handleChange));
                },
              );
            } else {
              return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.done_all,
                            size: 100, color: Theme.of(context).primaryColor),
                        Text(
                          "Use '+' button bellow to add items to your list.",
                          textAlign: TextAlign.center,
                        ),
                      ]));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleAddClicked,
        tooltip: 'Add item',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    super.dispose();
    listBloc.close();
  }
}
