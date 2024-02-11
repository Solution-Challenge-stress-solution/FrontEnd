import 'package:flutter/material.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({
    super.key,
  });

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  void _deleteDiary() {
    print("Diary entry deleted");
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        _deleteDiary();
      },
      itemBuilder: (BuildContext context) {
        return {'delete': 'Delete Diary'}.entries.map((entry) {
          return PopupMenuItem<String>(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList();
      },
      child: Icon(Icons.more_vert),
    );
  }
}
