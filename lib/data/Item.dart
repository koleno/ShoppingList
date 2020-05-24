class Item {
  final int id;
  final bool checked;
  final String title;

  Item({this.id, this.checked, this.title});

  Map<String, dynamic> toMap() {
    return {
      'checked': checked ? 1 : 0,
      'title': title,
    };
  }

}