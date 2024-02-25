import 'package:flutter/material.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget(
      {super.key,
      required this.diaryId,
      required this.deleteDiary,
      required this.fetchDiary});

  final int? diaryId;
  final Function(int?) deleteDiary;
  final Function() fetchDiary;

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        widget.deleteDiary(widget.diaryId).then((_) {
          widget.fetchDiary();
        });
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
